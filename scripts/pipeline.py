import os

os.environ['KAGGLE_USERNAME'] = "YOUR_USERNAME_HERE"
os.environ['KAGGLE_KEY'] = "YOUR_KEY_HERE"

# 2. Bring in the libraries
import pandas as pd
import numpy as np
import kagglehub

def run_pipeline():
    print("Authenticating and downloading dataset...")
    
    path = kagglehub.dataset_download("uom190346a/e-commerce-customer-behavior-dataset")
    raw_file = os.path.join(path, "E-commerce Customer Behavior - Sheet1.csv")
    df = pd.read_csv(raw_file)

    # Strategic Engineering (The "PM" Layer)
    print("Engineering growth features...")
    df['Churn_Risk'] = np.where(df['Days Since Last Purchase'] > 40, 1, 0)
    
    spend_threshold = df['Total Spend'].quantile(0.75)
    df['User_Segment'] = np.where(df['Total Spend'] > spend_threshold, 'Whale', 'Standard')
    df['Revenue_At_Risk'] = df['Total Spend'] * df['Churn_Risk']

    # Export for the Dashboard
    os.makedirs("app", exist_ok=True)
    df.to_csv("app/processed_data.csv", index=False)
    
    print("✅ Pipeline Complete: Data synced to Dashboard.")

if __name__ == "__main__":
    run_pipeline()
