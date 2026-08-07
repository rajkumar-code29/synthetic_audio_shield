import base64
import audioop
import numpy as np

def process_audio_bytes(audio_bytes: bytes) -> np.ndarray:
    """
    convert 8kHz u-law to 16kHz PCM,
    and also normalises to a float32 NumPy array for Whisper.
    """   
    # Convert u-law to 16-bit PCM
    pcm_audio = audioop.ulaw2lin(audio_bytes, 2)
    
    # Resample from 8000Hz to 16000Hz for Whisper standard
    resampled_pcm, _ = audioop.ratecv(pcm_audio, 2, 1, 8000, 16000, None)
    
    # Convert raw bytes to a normalised float32 NumPy array
    audio_np = np.frombuffer(resampled_pcm, dtype=np.int16).astype(np.float32) / 32768.0
    
    return audio_np