import os
import redis.asyncio as redis
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

POSTGRES_URL = os.environ.get(
    "DATABASE_URL", 
    "postgresql+asyncpg://ubuntu:123456789@localhost:5432/synthetic_audio_shield"
)
REDIS_URL = os.environ.get("REDIS_URL", "redis://localhost:6379/0")

# Async Postgres Engine & Session Maker
engine = create_async_engine(
    POSTGRES_URL, 
    pool_size=10, 
    max_overflow=20, 
    echo=False
)
SessionLocal = async_sessionmaker(
    bind=engine, 
    expire_on_commit=False, 
    class_=AsyncSession
)

# Async Redis Client
redis_client = redis.from_url(REDIS_URL, decode_responses=True)

# Dependency Injection helper for FastAPI routes
async def get_db_session():
    async with SessionLocal() as session:
        yield session