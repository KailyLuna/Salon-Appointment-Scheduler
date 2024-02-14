#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Annonymous Hair Salon ~~~~~\n"
echo -e "\nWelcome to Annonymous Hair Salon!" 

SERVICE_MENU() {
  # SQL query to get data from the table 'services'
  SERVICE_ID=$($PSQL "SELECT * FROM services")
  
  # display services offered
  echo -e "\nHere are the services offered:"

  # a while statement to display the services in a list form going down
  echo "$SERVICE_ID" | while IFS=" " read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done

  # reading the input from user on which service they chose
  read SERVICE_ID_SELECTED

  # if input is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # give error message
    echo -e "\nThat is not a valid service number."

    # then redisplay services offered
    SERVICE_MENU
  else 
    # if their input was correct, ask for their number 
    echo -e "\nWhat's your phone number?"

    # reading the user input for a phone number
    read CUSTOMER_PHONE

    # SQL query for retrieving the name from customers table
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # if the customer does NOT exist
    if [[ -z $CUSTOMER_NAME ]]
    then
      # tell user their name isn't in database 
      echo -e "\nI don't have a record for you. Let us put you in the database."
      
      # get new customer name
      echo "What's your name?"
      read CUSTOMER_NAME
      
      # insert new customer into customers table
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi

    # get service id info
    SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    SERVICE_INFO_FORMATTED=$(echo $SERVICE_INFO)

    # ask the user what time they would like their appointment scheduled
    echo -e "\nWhat time would you like your "$SERVICE_INFO_FORMATTED"?"

    # read input from user
    read SERVICE_TIME

    # get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # insert the data into appointments table
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES('$SERVICE_ID_SELECTED','$CUSTOMER_ID','$SERVICE_TIME')")

    # display a message that tells the user what service and time they made an appointment
    echo -e "\nI have put you down for a $SERVICE_INFO_FORMATTED at $SERVICE_TIME, $(echo $CUSTOMER_NAME)."
  fi

}

EXIT () {
  echo -e "\nThank you for stopping in~!"
}

SERVICE_MENU
EXIT
