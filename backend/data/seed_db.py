import os
import sys

backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)


import json
import asyncio
import logging
from sqlalchemy import select
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from redis.asyncio import Redis
from app.db.models import Base, Keyword
from app.db.connection import POSTGRES_URL, REDIS_URL

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def seed_databases(json_file_path: str):
    # Setting up Connections
    engine = create_async_engine(POSTGRES_URL, echo=False)
    SessionLocal = async_sessionmaker(bind=engine, expire_on_commit=False)
    redis_client = Redis.from_url(REDIS_URL, decode_responses=True)

    # Create PostgreSQL Tables
    logger.info("Initialising PostgreSQL schema...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    # Load JSON Data
    logger.info(f"Loading tripwire data from {json_file_path}...")
    try:
        with open(json_file_path, 'r') as f:
            tripwires = json.load(f)
    except FileNotFoundError:
        logger.error(f"File not found: {json_file_path}")
        return
    except json.JSONDecodeError:
        logger.error(f"Invalid JSON in file: {json_file_path}")
        return

    logger.info(f"Found {len(tripwires)} keywords to process.")

    async with SessionLocal() as session:
        # Redis pipeline to batch insertions for caching efficiency
        pipe = redis_client.pipeline()
        
        inserted_count = 0
        updated_count = 0

        for data in tripwires:
            # Extract values, handling variations in JSON keys
            ngram = data.get("ngram", data.get("keyword", data.get("phrase", data.get("word"))))

            if not ngram:
                continue # skip
            
            weight = float(data.get("weight", data.get("score", 0.5)))
            bucket = data.get("threat_bucket", data.get("bucket", "General_Risk"))

            # Check if keyword exists
            stmt = select(Keyword).where(Keyword.ngram == ngram)
            result = await session.execute(stmt)
            existing_kw = result.scalar_one_or_none()

            if not existing_kw:
                new_kw = Keyword(ngram=ngram, threat_bucket=bucket, weight=weight)
                session.add(new_kw)
                inserted_count += 1
            else:
                # Update existing record in case of changes
                if existing_kw.weight != weight or existing_kw.threat_bucket != bucket:
                    existing_kw.weight = weight
                    existing_kw.threat_bucket = bucket
                    updated_count += 1

            # Store as Hash in Redis: Key=tripwire:{ngram}, Fields=weight,threat_bucket
            redis_key = f"tripwire:{ngram}"
            pipe.hset(redis_key, mapping={
                "weight": weight,
                "threat_bucket": bucket
            })

        # Commit all Postgres changes
        logger.info("Committing to PostgreSQL...")
        await session.commit()
        
        # Execute Redis pipeline
        logger.info("Executing Redis pipeline...")
        await pipe.execute()

    logger.info("=== Migration Complete ===")
    logger.info(f"New keywords added to Postgres: {inserted_count}")
    logger.info(f"Keywords updated in Postgres: {updated_count}")
    logger.info(f"Total keys loaded into Redis cache: {len(tripwires)}")

    # Cleanup connections
    await engine.dispose()
    await redis_client.aclose()

if __name__ == "__main__":
    # Path to where the script is executed
    json_path = os.path.join(os.path.dirname(__file__), 'redis_tripwires.json')
    
    # Run async migration
    asyncio.run(seed_databases(json_path))