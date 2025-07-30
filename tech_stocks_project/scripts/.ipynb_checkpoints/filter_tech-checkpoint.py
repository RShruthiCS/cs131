import pandas as pd

df = pd.read_csv('data/sp500_companies.csv')
tech_df = df[df['Sector'] == 'Technology']
tech_df.to_csv('data/tech_filtered.csv', index=False)