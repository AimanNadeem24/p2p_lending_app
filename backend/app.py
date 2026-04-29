from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import pickle
import numpy as np
import pandas as pd
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import load_model
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- 1. LOAD ALL SAVED MODELS & TOKENIZERS ---
# (Make sure the file names match what is in your backend folder)
structured_model = joblib.load("pipeline.joblib") 
nlp_model = load_model("best_ae_text_model.keras") # Or .keras depending on how you saved it

with open("tokenizer.pkl", "rb") as f:
    tokenizer = pickle.load(f)

# --- 2. DEFINE WHAT DATA FLUTTER WILL SEND ---
class LoanRequest(BaseModel):
    loanAmount: float
    loanTerm: int
    creditScore: float
    annualIncome: float = 60000.0  # Default if Flutter doesn't send it
    dti: float = 15.0
    description: str = "I need a loan to consolidate my debt."
    homeOwnership: str = "MORTGAGE" # "RENT", "OWN", "MORTGAGE"
    purpose: str = "debt_consolidation"

# --- 3. THE PREDICTION ENDPOINT ---
@app.post("/predict")
def predict_risk(data: LoanRequest):
    
    # A. Text Processing (Neural Tokenization Pipeline)
    # Convert text to sequences, pad to 115, and get prediction
    sequences = tokenizer.texts_to_sequences([data.description])
    padded_seq = pad_sequences(sequences, maxlen=115, padding='post', truncating='post')
    
    # Get the text probability from the Keras model
    text_prob = nlp_model.predict(padded_seq)[0][0]

    # B. Structured Data Processing
    # Create a DataFrame with all 71 expected columns initialized to 0
    expected_columns = [
        "pub_rec", "annual_inc", "dti", "delinq_2yrs", "inq_last_6mths", "loan_amnt",
        "revol_bal", "revol_util", "open_acc", "fico_score", "term_months", 
        "credit_history_months", "installment_income_ratio", "income_verified", 
        "emp_length_unknown", "emp_title_unknown", "home_ownership_MORTGAGE", 
        "home_ownership_NONE", "home_ownership_OTHER", "home_ownership_OWN", 
        "home_ownership_RENT", "purpose_car", "purpose_credit_card", 
        "purpose_debt_consolidation", "purpose_educational", "purpose_home_improvement", 
        "purpose_house", "purpose_major_purchase", "purpose_medical", "purpose_moving", 
        "purpose_other", "purpose_renewable_energy", "purpose_small_business", 
        "purpose_vacation", "purpose_wedding", "sub_grade_A1", "sub_grade_A2", 
        "sub_grade_A3", "sub_grade_A4", "sub_grade_A5", "sub_grade_B1", "sub_grade_B2", 
        "sub_grade_B3", "sub_grade_B4", "sub_grade_B5", "sub_grade_C1", "sub_grade_C2", 
        "sub_grade_C3", "sub_grade_C4", "sub_grade_C5", "sub_grade_D1", "sub_grade_D2", 
        "sub_grade_D3", "sub_grade_D4", "sub_grade_D5", "sub_grade_E1", "sub_grade_E2", 
        "sub_grade_E3", "sub_grade_E4", "sub_grade_E5", "sub_grade_F1", "sub_grade_F2", 
        "sub_grade_F3", "sub_grade_F4", "sub_grade_F5", "sub_grade_G1", "sub_grade_G2", 
        "sub_grade_G3", "sub_grade_G4", "sub_grade_G5", "text_probability"
    ]
    
    df = pd.DataFrame(0, index=[0], columns=expected_columns)
    
    # C. Fill the DataFrame with the Flutter data
    df.at[0, 'loan_amnt'] = data.loanAmount
    df.at[0, 'term_months'] = data.loanTerm
    df.at[0, 'fico_score'] = data.creditScore
    df.at[0, 'annual_inc'] = data.annualIncome
    df.at[0, 'dti'] = data.dti
    df.at[0, 'text_probability'] = float(text_prob)
    
    # One-hot encoding mapping for the prototype
    home_col = f"home_ownership_{data.homeOwnership}"
    if home_col in df.columns:
        df.at[0, home_col] = 1
        
    purpose_col = f"purpose_{data.purpose}"
    if purpose_col in df.columns:
        df.at[0, purpose_col] = 1
        
    # Defaulting to an average sub_grade for the prototype
    df.at[0, 'sub_grade_C1'] = 1 

    # D. Final Prediction
    # predict_proba returns [[prob_fully_paid, prob_default]]
    probabilities = structured_model.predict_proba(df)[0]
    
    # Assuming index 1 is the probability of default/charge-off
    default_prob = probabilities[1] 
    
    # Calculate a friendly risk score (0-100) where 100 is safest
    risk_score = (1 - default_prob) * 100
    
    # Category logic
    category = "Low Risk"
    if default_prob > 0.5:
        category = "High Risk"
    elif default_prob > 0.2:
        category = "Medium Risk"

    return {
        "riskScore": round(risk_score),
        "riskCategory": category,
        "defaultProbability": round(default_prob * 100)
    }

# To run: uvicorn app:app --reload