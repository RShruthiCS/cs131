import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import glob

print("Starting plot generation...")

# Create plots directory if it doesn't exist
os.makedirs("plots", exist_ok=True)
print("Ensured 'plots/' directory exists.")

# Find Spark output CSV file
output_files = glob.glob("output/industry_metrics/part-*.csv")
if not output_files:
    raise FileNotFoundError("No output CSV file found in output/industry_metrics/")
output_path = output_files[0]
print(f"Reading CSV from: {output_path}")

# Read CSV into dataframe
df = pd.read_csv(output_path)
print("Data preview:")
print(df.head())

# Convert relevant columns to numeric
df["AvgReturn"] = pd.to_numeric(df["AvgReturn"], errors='coerce')
df["Volatility"] = pd.to_numeric(df["Volatility"], errors='coerce')

# Sort by volatility descending for bar plot
df_sorted = df.sort_values("Volatility", ascending=False)

# Plot 1: Bar chart of Volatility by Industry
plt.figure(figsize=(10, 6))
sns.barplot(x="Volatility", y="Industry", data=df_sorted, palette="rocket")
plt.title("Volatility by Tech Industry")
plt.xlabel("Volatility (Std Dev of Daily Return)")
plt.ylabel("Industry")
plt.tight_layout()
print("Saving volatility_by_industry.png...")
plt.savefig("plots/volatility_by_industry.png")
plt.close()

# Plot 2: Scatter plot of Volatility vs. Average Return
plt.figure(figsize=(8, 6))
sns.scatterplot(x="Volatility", y="AvgReturn", hue="Industry", data=df_sorted, s=100)
plt.title("Risk vs Return by Industry")
plt.xlabel("Volatility (Risk)")
plt.ylabel("Average Return")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()
print("Saving risk_vs_return.png...")
plt.savefig("plots/risk_vs_return.png")
plt.close()

print("Plot generation complete. Check the 'plots/' directory for images.")