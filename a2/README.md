# datacollector.sh

## 📌 What this command does

This script automates the process of downloading, extracting, and analyzing tabular datasets from the UCI Machine Learning Repository (or similar sources). It supports both `.zip` and `.csv` files. The tool generates a `summary.md` file for each selected CSV containing:

- A list of all features (columns) with index numbers
- Minimum, Maximum, Mean, and Standard Deviation for selected numerical columns

---

## ▶️ How to use this command

### 1. Clone your GitHub repo:

```bash
git clone https://github.com/RShruthiCS/cs131
cd cs131/a2
```

### 2. Run the script:
```bash
./datacollector.sh
```

### 3. Follow the prompts:
- Enter the URL to a dataset (e.g., UCI ZIP or CSV file)
- Choose the CSV file (if it's zipped)
- View the list of feature names
- Enter the index numbers of the numerical columns (space-separated)

### 4. View the results:
- The script creates a file called `summary.md`
- It contains:
  - The feature index and names
  - A table of min, max, mean, and standard deviation for each selected numerical column


---

## 🧪 Demo

$ ./datacollector.sh
Enter the URL to the dataset (.zip or .csv):
https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv
Downloading...
Found CSV file:
1. downloaded_file.csv

Enter the number of the CSV file you want to summarize:
1
You selected: downloaded_file.csv

## Feature Index and Names
1. fixed acidity
2. volatile acidity
3. citric acid
4. residual sugar
5. chlorides
6. free sulfur dioxide
7. total sulfur dioxide
8. density
9. pH
10. sulphates
11. alcohol
12. quality

Enter the index numbers of numerical columns (e.g., 1 2 3 5 6):
1 2 3 4 5 6 7 8 9 10 11 12


Then summary.md contains:

## Statistics (Numerical Features)
| Index | Feature           | Min  | Max  | Mean   | StdDev |
|-------|-------------------|------|------|--------|--------|
| 1     | fixed acidity     | 4.60 | 15.90 | 8.320 | 1.741  |
| 2     | volatile acidity  | 0.12 | 1.58  | 0.528 | 0.179  |
| 3     | citric acid       | 0.00 | 1.00  | 0.271 | 0.195  |
...
