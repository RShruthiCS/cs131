# A4: Spark MLlib Decision Tree Regression

This notebook trains a Decision Tree Regression model using PySpark MLlib to predict `total_amount` in NYC yellow taxi trip data (April 2019).

## 📊 Features Used
- `passenger_count`
- `PULocationID` → renamed to `pickup`
- `DOLocationID` → renamed to `dropoff`

## ✅ Tasks Completed
- Selected required columns from CSV
- Split dataset into train/test
- Built a Spark MLlib pipeline
- Trained Decision Tree Regressor
- Showed predictions and evaluated with RMSE

## 🧪 Result
**RMSE:** ~324.89

## 🔧 Environment
- PySpark via Docker
- Jupyter Notebook (`jupyter/pyspark-notebook` image)

