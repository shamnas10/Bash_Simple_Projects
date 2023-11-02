
db_name="mydatabase"

start=$(date +%s%3N)


namelist=('shamnas' 'arun' 'abhinandh' 'vishnu' 'dona' 'safana' 'jeejo' 'mujeeb' 'safvan' 'hisham' 'raheem' 'anandhan' 'raja' 'kumar' 'rithu' 'bathool' 'hashir' 'veena' 'varun' 'sona' 'madhu' 'kannan' 'kishore' 'muneer')
domain=('gmail'  'yahoo' 'vinam' 'example')

generate_name(){
	randomname=${namelist[$((RANDOM % ${#namelist[@]}))]}
	echo "$randomname"
}

generate_email(){
	randomemail=${domain[$((RANDOM % ${#domain[@]}))]}
	echo "$randomemail"
}

country=('india' 'usa' 'africa' 'argentina' 'brazil' 'skorea' 'peru' 'chili' 'france' 'spain' 'portugal' 'colombia' 'qatar' 'uae' 'germany')

generate_country(){
     randomcountry=${country[$((RANDOM%${#country[@]}))]}
     echo "$randomcountry"

}

generate_random_dob(){
    randomyear=$(( (RANDOM % (2023 - 1900 + 1)) + 1900 ))
    randommonth=$(( (RANDOM % 12) + 1 ))
    randomday=$(( (RANDOM % 28) + 1))
    echo "$randomyear"."$randommonth"."$randomday"
}

activity=(1 2 3 4 5 6 7)
generate_activity_type(){
    randomactivity=${activity[$((RANDOM%${#activity[@]}))]}
    echo "$randomactivity"

}

campaign=(1 2 3 4 5 6 7 8 9 10)
generate_campaign(){
    randomactivity=${campaign[$((RANDOM%${#campaign[@]}))]}
    echo "$randomactivity"

}


generate_random_date(){
    randomyear=2023
    randommonth=08
    randomday=$(( (RANDOM % 28) + 1))
    echo "$randomyear"."$randommonth"."$randomday"

}

num=1000000

 j=1
# insert into contacts table
for ((i=1;i<=num;i++));do 
        
    
	    name=$(generate_name)
        email=$(generate_email)
	
        batch_data+="INSERT INTO contacts (name, email) VALUES ('$name', '$name$((RANDOM))@$email.com');SELECT LAST_INSERT_ID();"
        batch_data+="SET @result = LAST_INSERT_ID();"
    

#insert into contact_details_table   
        
        dob="$(generate_random_dob)"
        country=$(generate_country)
        
        batch_data+="INSERT INTO contact_details (contactid,dob,city,country) VALUES (@result, '$dob', '$country$((RANDOM))','$country');"
        
        
#insert into contact_activity table
       
        campaign=$(generate_campaign)  
        actvt=$(generate_activity_type)
        date=$(generate_random_date)

        if [[ $actvt -eq 2 ]]; then
            temp=2
        else
             temp=1
        fi
        
        for ((k=temp;k<=actvt;k++));do
            
                activitytype=$((k))
                if [[ $k -eq 1 || $k -eq 2 ]]; then
                      activitydate="2023-08-01"
                else
                      activitydate=$date
                fi
                if [[ $k -eq 2 && $actvt -gt 2 ]]; then
                      continue
                elif [[ $k -eq 5 && $actvt -eq 7 ]]; then
                      continue
                elif [[ $k -eq 6 && $actvt -eq 7 ]]; then
                      continue
                else
                     
                batch_data+="INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES (@result, $campaign,$activitytype,'$activitydate');"
                
                
                fi 
            
        done
        j=$((j+1))
    if [[ $j -eq 1000 ]]; then
   
        mysql --defaults-file=~/.my.cnf -D mydatabase <<EOF
        START TRANSACTION;
        $batch_data
        COMMIT;
    
EOF
    j=1
    batch_data=""
    fi
    

              
       
done
    
end=$(date +%s%3N)
execution_time=$((end - start))
echo "Execution time: $execution_time ms"



    
