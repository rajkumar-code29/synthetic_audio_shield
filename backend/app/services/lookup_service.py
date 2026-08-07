import json
from sqlalchemy import select
from app.db.connection import redis_client, SessionLocal
from app.db.models import ReportedNumber

async def check_number_reputation(phone_number: str) -> dict | None:
    """
    Checks if a number is a reported number by users and returns a dict with 
    report details, or None if not found
    """
    redis_key = f"caller:{phone_number}"

    # Check Redis Cache First
    cached_data = await redis_client.get(redis_key)
    if cached_data:
        return json.loads(cached_data)

    # If Cache Miss: Check PostgreSQL
    async with SessionLocal() as session:
        stmt = select(ReportedNumber).where(ReportedNumber.phone_number == phone_number)
        result = await session.execute(stmt)
        record = result.scalar_one_or_none()

        if record:
            threat_data = {
                "phone_number": record.phone_number,
                "report_count": record.report_count,
                "categories": record.categories
            }
            # Populate Redis for next time (with a 24-hour TTL)
            await redis_client.setex(
                redis_key, 
                86400, 
                json.dumps(threat_data)
            )
            return threat_data

    # Number is not reported
    return None