#!/bin/bash

namelist=('shamnas' 'arun' 'abhinandh' 'vishnu' 'dona' 'safana' 'jeejo' 'mujeeb' 'safvan' 'hisham' 'raheem' 'anandhan' 'raja' 'kumar' 'rithu' 'bathool' 'hashir' 'veena' 'varun' 'sona' 'madhu' 'kannan' 'kishore' 'muneer')
domain=('gmail' 'yahoo' 'vinam' 'example')

generate_name() {
    randomname=${namelist[$((RANDOM % ${#namelist[@]}))]}
    echo "$randomname"
}

generate_email() {
    randomemail=${domain[$((RANDOM % ${#domain[@]}))]}
    echo "$randomemail"
}

num_records=100000  # Number of records to generate
output_file="output.csv"  # Output CSV file

# Create or truncate the output file
> "$output_file"

# Generate random data and write to the CSV file
for ((i = 1; i <= num_records; i++)); do
    name=$(generate_name)
    email=$(generate_email)
    echo "$name$i,$name@$email.com" >> "$output_file"
done

echo "CSV file with $num_records records has been generated: $output_file"


