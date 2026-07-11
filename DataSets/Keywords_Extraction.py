import os
import json
import pandas as pd
import re
from sklearn.feature_extraction.text import CountVectorizer


# Regional filters 

DISCARD_TERMS = ['irs', 'ssn', 'aadhar', 'pan card', 'sbi', 'jio', 'target gift', 'social security', 'rupees']
UK_TERMS = ['hmrc', 'royal mail', 'pounds', 'pence', 'dwp', 'national insurance', 'action fraud', '£', 'uk border']

# Broad terms to categorize the dynamically found phrases
BUCKET_ROOTS = {
    "Urgency_Threat": ['expire', 'suspend', 'immediate', 'warrant', 'arrest', 'close', 'illegal', 'cancel', 'law', 'court'],
    "Authority_Impersonation": ['bank', 'manager', 'officer', 'support', 'care', 'hmrc', 'police', 'verify', 'customs', 'amazon', 'microsoft'],
    "Financial_Extraction": ['card', 'account', 'kyc', 'otp', 'transfer', 'crypto', 'won', 'cash', 'prize', 'fee', 'payment', 'claim', 'award'],
    "Remote_Access": ['desk', 'viewer', 'download', 'press', 'click', 'link', 'password', 'login', 'app']
}


# Data Loading

all_transcripts = []

csv_file = "dataset1.csv"
if os.path.exists(csv_file):
    df_csv = pd.read_csv(csv_file)
    if "Text" in df_csv.columns:
        all_transcripts.extend(df_csv["Text"].dropna().astype(str).tolist())

txt_files = ["dataset1.txt", "dataset2.txt"]
for txt_f in txt_files:
    if os.path.exists(txt_f):
        with open(txt_f, 'r', encoding='utf-8', errors='ignore') as f:
            for line in f:
                line_str = line.strip()
                if line_str:
                    if "\t" in line_str:
                        parts = line_str.split("\t", 1)
                        if len(parts) > 1:
                            all_transcripts.append(parts[1])
                    else:
                        all_transcripts.append(line_str)

print(f"Loaded {len(all_transcripts)} raw strings. Filtering regions...")


# Region Filtering

valid_scripts = []
for text in all_transcripts:
    text_lower = text.lower()
    # Drop irrelevant/foreign scams
    if not any(term in text_lower for term in DISCARD_TERMS):
        valid_scripts.append(text_lower)

print(f"Kept {len(valid_scripts)} valid English/UK scripts. Running NLP Extraction...")


# N-GRAM Extraction

vectorizer = CountVectorizer(ngram_range=(2, 4), stop_words='english', min_df=2)

try:
    # mapping repeated phrase in the dataset
    X = vectorizer.fit_transform(valid_scripts)
    phrases = vectorizer.get_feature_names_out()
    frequencies = X.sum(axis=0).A1
    
    # DataFrame of phrases and count of how many times they appeared
    phrase_df = pd.DataFrame({'phrase': phrases, 'frequency': frequencies})
    
    # Keeping high-confidence phrases that appear more than 3 times
    phrase_df = phrase_df[phrase_df['frequency'] > 3]
    # Sorting by commonly used phrases by scammers
    phrase_df = phrase_df.sort_values(by='frequency', ascending=False)
except ValueError:
    print("Not enough data passed the filters to extract patterns.")
    phrase_df = pd.DataFrame(columns=['phrase', 'frequency'])


# Categorisation & export

redis_seed_data = []

def assign_bucket(phrase):
    """Checks the dynamic phrase against our root words to assign a bucket."""
    for bucket, roots in BUCKET_ROOTS.items():
        if any(root in phrase for root in roots):
            return bucket
    return "General_Suspicion" # Fallback bucket

for _, row in phrase_df.iterrows():
    phrase = row['phrase']
    
    # Assign Region
    region = "UK_SPECIFIC" if any(uk_term in phrase for uk_term in UK_TERMS) else "GENERAL_ENGLISH"
    
    # Assign Bucket
    bucket = assign_bucket(phrase)
    
    redis_seed_data.append({
        "phrase": phrase,
        "bucket": bucket,
        "region": region,
        "occurrences": int(row['frequency']) # Helpful for setting Redis weights later
    })

# Saving structured data
output_json_file = "redis_tripwires.json"
with open(output_json_file, 'w', encoding='utf-8') as f:
    json.dump(redis_seed_data, f, indent=2)

print(f"\n--- Dynamic Extraction Complete ---")
print(f"Algorithm discovered {len(redis_seed_data)} high-frequency tripwire keys.")
print(f"Saved database-ready file as: '{output_json_file}'")

# Need to update in the following way 
# auto run script and update the db for new keywords based on new datasets