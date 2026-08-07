import re
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

try:
    nltk.data.find('sentiment/vader_lexicon.zip')
except LookupError:
    nltk.download('vader_lexicon')

sia = SentimentIntensityAnalyzer()
SCAM_THRESHOLD = 1.5

def extract_ngrams(text, max_n=4):
    clean_text = re.sub(r'[^\w\s]', '', text.lower())
    words = clean_text.split()
    ngrams = []
    
    for n in range(1, max_n + 1):
        for i in range(len(words) - n + 1):
            ngrams.append(" ".join(words[i:i+n]))
    return ngrams

async def evaluate_transcript_chunk(text, call_state, redis_client):
    sentiment = sia.polarity_scores(text)
    compound_score = sentiment['compound']
    call_state["last_sentiment"] = compound_score

    sentiment_risk = 0.0
    if compound_score < -0.2:
        sentiment_risk = abs(compound_score) * 0.5

    ngrams = extract_ngrams(text)
    chunk_tripwire_weight = 0.0

    if ngrams:
        # Use async Redis pipeline for zero blocking
        pipe = redis_client.pipeline()
        for ngram in ngrams:
            pipe.hgetall(f"tripwire:{ngram}")
        
        # Await the batched results
        results = await pipe.execute()

        for ngram, data in zip(ngrams, results):
            if data:
                weight = float(data.get("weight", 0.5))
                bucket = data.get("threat_bucket", "General_Risk")

                if ngram not in call_state["matched_tripwires"]:
                    call_state["matched_tripwires"][ngram] = weight
                    call_state["buckets_hit"].add(bucket)
                    chunk_tripwire_weight += weight

    if chunk_tripwire_weight > 0 or compound_score < -0.6:
        call_state["raw_score"] += (chunk_tripwire_weight + sentiment_risk)

    category_count = len(call_state["buckets_hit"])
    multiplier = 1.5 if category_count >= 2 else 1.0
    call_state["total_score"] = round(call_state["raw_score"] * multiplier, 2)

    if call_state["total_score"] >= SCAM_THRESHOLD:
        call_state["is_scam"] = True

    return call_state