import pytest
from unittest.mock import MagicMock, AsyncMock
from app.services.scam_engine import extract_ngrams, evaluate_transcript_chunk

def test_extract_ngrams():
    text = "Hello world! This is a test."
    ngrams = extract_ngrams(text)
    
    # Assert punctuation is stripped and lowercased
    assert "hello world" in ngrams
    assert "hello world this is" in ngrams
    assert "," not in ngrams[0]

@pytest.mark.asyncio
async def test_evaluate_transcript_chunk_multiplier():
    # Mock Redis pipeline behavior
    mock_redis = MagicMock()
    mock_pipe = MagicMock()
    mock_redis.pipeline.return_value = mock_pipe
     
    
    # Mock the Redis responses for the ngrams
    mock_pipe.execute = AsyncMock(return_value=[
        {"weight": 0.6, "threat_bucket": "Authority_Impersonation"}, # bank
        None,                                                        # account
        {"weight": 1.0, "threat_bucket": "Financial_Risk"}           # bank account
    ])

    text = "bank account"
    call_state = {
        "raw_score": 0.0, "total_score": 0.0,
        "matched_tripwires": {}, "buckets_hit": set(), "is_scam": False
    }
    
    new_state = await evaluate_transcript_chunk(text, call_state, mock_redis)
    
    # 0.6 + 1.0 = 1.6 raw score. 
    # Hits 2 buckets, so multiplier is 1.5x. Total should be 1.6 * 1.5 = 2.4
    assert new_state["raw_score"] == 1.6
    assert new_state["total_score"] == 2.4
    assert new_state["is_scam"] is True