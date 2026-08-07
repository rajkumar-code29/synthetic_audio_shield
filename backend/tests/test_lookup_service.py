import pytest
from unittest.mock import AsyncMock, MagicMock, patch
from app.services.lookup_service import check_number_reputation

@pytest.mark.asyncio
@patch("app.services.lookup_service.redis_client")
async def test_cache_hit_returns_immediately(mock_redis):
    # Simulating a cached JSON payload in Redis
    mock_redis.get.return_value = '{"phone_number": "+1234567890", "report_count": 5, "categories": ["Scam"]}'
    
    result = await check_number_reputation("+1234567890")
    
    assert result is not None
    assert result["report_count"] == 5
    assert "Scam" in result["categories"]
    
    # Ensuring Redis was called with correct format
    mock_redis.get.assert_called_once_with("caller:+1234567890")

@pytest.mark.asyncio
@patch("app.services.lookup_service.SessionLocal")
@patch("app.services.lookup_service.redis_client")
async def test_clean_number_misses_both(mock_redis, mock_db_session):
    # Simulate Redis miss
    mock_redis.get.return_value = None
    
    # Simulate PostgreSQL miss
    mock_session_instance = mock_db_session.return_value.__aenter__.return_value
    mock_execute_result = MagicMock()
    mock_execute_result.scalar_one_or_none.return_value = None

    mock_session_instance.execute = AsyncMock(return_value=mock_execute_result)
    
    result = await check_number_reputation("+1999999999")
    
    assert result is None