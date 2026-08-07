import numpy as np
from app.services.audio_processor import process_audio_bytes

def test_process_audio_bytes_conversion():
    # Generate 160 bytes of standard u-law silence
    dummy_ulaw = b'\xff' * 160 # \xff is silence
    
    result = process_audio_bytes(dummy_ulaw)
    
    # The engine requires formatted numpy arrays
    assert isinstance(result, np.ndarray)
    assert result.dtype == np.float32
    
    # Resampling from 8kHz to 16kHz
    assert 318 <= len(result) <= 322
    
    # values are normalized between -1.0 and 1.0
    assert np.max(result) <= 1.0
    assert np.min(result) >= -1.0