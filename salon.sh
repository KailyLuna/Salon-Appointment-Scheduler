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
  fi

}

SCHEDULE_MENU() {
  echo "Schedule menu"
}

EXIT () {
  echo -e "\nThank you for stopping in~!"
}

#MAIN_MENU

SERVICE_MENU
