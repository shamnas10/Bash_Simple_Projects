start=$(date +%s%3N)
DB_NAME="mydatabase"
CSV_FILE="/home/shamnas/Documents/employee_details.csv"
TABLE_NAME="employee" 


my_value=""

# Validate email function
validate_email() {
    local email=$1
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 1
    fi
    return 0
}

# Validate name function
validate_firstname() {
    local firstname=$1
    if [[ ! $firstname =~ ^[a-zA-Z\s-]{2,}$ ]]; then
        return 1
    fi
    return 0
}
validate_lastname() {
    local lastname=$1
    if [[ ! $lastname =~ ^[a-zA-Z\s-]{1,}$ ]]; then
        return 1
    fi
    return 0
}


validate_username() {
    local username=$1
    if [[ ! $username =~ ^[a-zA-Z0-9\s-]{3,}$ ]]; then
        return 1
    fi
    return 0
}

validate_password() {
    local password=$1
    
    if [[ ! $password =~ ^[a-zA-Z0-9@%*+_-]{3,}$ ]]; then
        return 1  # Password is valid
    else
        return 0  # Password is not valid
    fi
}
validate_postalcode() {
    local postalcode=$1
    if [[ ! $postalcode =~ ^[a-zA-Z0-9\s-]{3,}$ ]]; then
        return 1
    fi
    return 0
}




while IFS="," read -r id username email password firstname lastname jobtitle company city state postalcode; 
do

    if [[ -z $firstname || -z $email || -z $username || -z $password || -z $jobtitle || -z $company || -z $city || -z $state || -z $postalcode ]]; then
        echo "Empty name or email or password or jobtitle or company or  city or state or postalcode  field. Skipping line."
        continue
    fi
    if ! validate_username "$username"; then
        echo "Invalid username: $username. Skipping line."
        continue
    fi
     if ! validate_email "$email"; then
        echo "Invalid email: $email. Skipping line."
        continue
    fi
   
    if ! validate_firstname "$firstname"; then
        echo "Invalid name: $firstname. Skipping line."
        continue
    fi

   
     if ! validate_lastname "$lastname"; then
        echo "Invalid lastname: $lastname. Skipping line."
        continue
    fi
    if ! validate_password "$password"; then
        echo "Invalid password: $password. Skipping line."
        continue
    fi
    if ! validate_postalcode "$postalcode"; then
        echo "Invalid postalcode: $postalcode. Skipping line."
        continue
    fi
 
    
    

 my_value+="('$id','$username','$email','$password','$firstname','$lastname','$jobtitle','$company','$city','$state','$postalcode'),"
done < "$CSV_FILE"

# Remove the trailing comma from my_values
my_value="${my_value%,}"

# my_value=$(echo "$my_value" | sed 's/,$//')

# Connect to the database and insert the values
mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "
INSERT INTO $TABLE_NAME(id,username,email,password,firstname,lastname,jobtitle,company,city,state,postalcode)
VALUES  $my_value;
"
end=$(date +%s%3N)
execution_time=$((end - start))
echo "Execution time: $execution_time ms"
