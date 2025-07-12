# grader.awk:
BEGIN {
    FS = ",";  # Set field separator to comma
    print "Student Grade Report";  # Header for output
    print "-------------------";
    high_score = -1;  # Initialize highest score
    low_score = 999;  # Initialize lowest score
}

# Skip the header row
NR == 1 { next }

# Process each student record
{
    # Store student data
    student_id = $1;
    name = $2;
    total = $3 + $4 + $5;  # Sum of grades (CS146, CS131, CS100W)
    totals[student_id] = total;  # Store in associative array
    names[student_id] = name;   # Store name
    grades[student_id] = $3 "," $4 "," $5;  # Store individual grades

    # Update highest and lowest scores
    if (total > high_score) {
        high_score = total;
        high_scorer = name;
    }
    if (total < low_score) {
        low_score = total;
        low_scorer = name;
    }
}

# User-defined function to calculate average and determine status
function calc_average_and_status(id, total,   avg) {
    avg = total / 3;  # Calculate average (3 courses)
    status = (avg >= 70) ? "Pass" : "Fail";  # Determine Pass/Fail
    return sprintf("Average: %.2f, Status: %s", avg, status);
}

# Print results for each student
END {
    print "\nIndividual Student Results:";
    print "-------------------------";
    for (id in totals) {
        printf "Student: %s\n", names[id];
        printf "Total Score: %d\n", totals[id];
        print calc_average_and_status(id, totals[id]);
        print "";
    }
    print "Summary:";
    print "-------";
    printf "Highest Scoring Student: %s (Total: %d)\n", high_scorer, high_score;
    printf "Lowest Scoring Student: %s (Total: %d)\n", low_scorer, low_score;
}
