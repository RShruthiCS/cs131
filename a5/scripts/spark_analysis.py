from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lag, stddev, avg
from pyspark.sql.window import Window
from pyspark.sql.types import DateType
from pyspark.sql.functions import to_date

spark = SparkSession.builder.appName("TechStockAnalysis").getOrCreate()

# Load tech companies (filtered)
companies = spark.read.csv("data/tech_filtered.csv", header=True, inferSchema=True)

# Load stock prices (daily)
stocks = spark.read.csv("data/sp500_stocks.csv", header=True, inferSchema=True)

# Select columns needed for join
companies = companies.select("Symbol", "Industry")

# Join stocks with tech companies on Symbol
tech_stocks = stocks.join(companies, on="Symbol", how="inner")

# Convert Date column to DateType
tech_stocks = tech_stocks.withColumn("Date", to_date(col("Date"), "yyyy-MM-dd"))

# Define window partitioned by Symbol ordered by Date
window_spec = Window.partitionBy("Symbol").orderBy("Date")

# Calculate previous day's Close price
tech_stocks = tech_stocks.withColumn("PrevClose", lag(col("Close")).over(window_spec))

# Calculate daily return: (Close - PrevClose) / PrevClose
tech_stocks = tech_stocks.withColumn("DailyReturn", (col("Close") - col("PrevClose")) / col("PrevClose"))

# Filter out rows where DailyReturn is null (first row per stock)
tech_stocks = tech_stocks.filter(col("DailyReturn").isNotNull())

# Aggregate average return and volatility by Industry
industry_metrics = tech_stocks.groupBy("Industry").agg(
    avg("DailyReturn").alias("AvgReturn"),
    stddev("DailyReturn").alias("Volatility")
).orderBy(col("Volatility").desc())

industry_metrics.show(truncate=False)

# Optionally save the result to CSV for plotting later
industry_metrics.coalesce(1).write.csv("output/industry_metrics", header=True, mode="overwrite")

spark.stop()



# run in Docker: spark-submit scripts/spark_analysis.py
