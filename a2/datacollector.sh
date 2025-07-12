#!/bin/bash

# Ask for the URL
echo "Enter the URL to the dataset (.zip or .csv):"
read url

# Set a download filename
if [[ "$url" == *.zip ]]; then
    filename="downloaded_file.zip"
else
    filename="downloaded_file.csv"
fi

# Download the file
echo "Downloading..."
wget -q "$url" -O "$filename"

# Check if it worked
if [[ $? -ne 0 ]]; then
    echo "Failed to download. Please check the URL."
    exit 1
fi

# Unzip if it's a .zip file
if [[ "$filename" == *.zip ]]; then
    echo "Unzipping $filename..."
    unzip -o "$filename" > /dev/null

    # Get list of CSVs from the zip
    csv_files=($(unzip -l "$filename" | awk '/.csv/ {print $NF}'))

    echo "Found CSV file(s):"
    for i in "${!csv_files[@]}"; do
        echo "$((i+1)). ${csv_files[$i]}"
    done
else
    csv_files=("$filename")
fi

# Ask user to choose a CSV file
echo ""
echo "Enter the number of the CSV file you want to summarize:"
read choice

selected_csv="${csv_files[$((choice-1))]}"

if [[ ! -f "$selected_csv" ]]; then
    echo "Selected file does not exist: $selected_csv"
    exit 1
fi

echo "You selected: $selected_csv"

# Read header row
header=$(head -n 1 "$selected_csv")

# Convert to array using comma as delimiter
IFS=';' read -ra columns <<< "$header"

# Print feature names with index numbers
echo ""
echo "## Feature Index and Names"
for i in "${!columns[@]}"; do
    col=$(echo "${columns[$i]}" | sed 's/^"//;s/"$//')
    echo "$((i+1)). $col"
done

echo ""
echo "Enter the index numbers of numerical columns (e.g., 1 2 3 5 6):"
read -a num_indices

# Create summary.md
summary_file="summary.md"
echo "# Feature Summary for $selected_csv" > "$summary_file"
echo "" >> "$summary_file"
echo "## Feature Index and Names" >> "$summary_file"
for i in "${!columns[@]}"; do
    col=$(echo "${columns[$i]}" | sed 's/^"//;s/"$//')
    echo "$((i+1)). $col" >> "$summary_file"
done

echo "" >> "$summary_file"
echo "## Statistics (Numerical Features)" >> "$summary_file"
echo '| Index | Feature | Min | Max | Mean | StdDev |' >> "$summary_file"
echo '|-------|---------|-----|-----|------|--------|' >> "$summary_file"

# Use tail to skip the header row
for index in "${num_indices[@]}"; do
    col_num=$((index))
    feature=$(echo "${columns[$((col_num-1))]}" | sed 's/^"//;s/"$//')

    stats=$(tail -n +2 "$selected_csv" | awk -F';' -v col="$col_num" '
    {
        gsub(/"/, "", $col)
        x[NR]=$col;
        sum+=$col;
        if (NR==1 || $col<min) min=$col;
        if (NR==1 || $col>max) max=$col;
    }
    END {
        mean = sum / NR;
        for (i=1;i<=NR;i++) {
            sq += (x[i]-mean)^2;
        }
        stddev = sqrt(sq/NR);
        printf "%.2f %.2f %.3f %.3f", min, max, mean, stddev;
    }')

    echo "| $index | $feature | $stats |" >> "$summary_file"
done
