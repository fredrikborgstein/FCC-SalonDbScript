#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~~Welcome to Frizzy Hair Salon~~~\n"

GET_SERVICES=$($PSQL "SELECT * FROM services")

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\nHere are your options:\n"
  echo "$GET_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo -e "$SERVICE_ID) $(echo $NAME | sed -r 's/^ *| *$//g')"
  done
  read SERVICE_ID_SELECTED

}

CHECK_IF_EXISTING_OR_NEW_CUSTOMER() {
  echo -e "\nEnter your phone number:"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "You are not a customer at the salon, please enter a name so we can register you: \n"
    read CUSTOMER_NAME
    ADD_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' ")
}

ADD_APPOINTMENT_TO_DB() {
  CHECK_IF_EXISTING_OR_NEW_CUSTOMER
  echo -e "Please enter your desireed time for your appointment: \n"
  read SERVICE_TIME
  ADD_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$GET_CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")
  SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED';")
  echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}


HIGHLIGHTING_FUNC() {
  ADD_APPOINTMENT_TO_DB
}

BLEACHING_FUNC() {
  ADD_APPOINTMENT_TO_DB
}

MENS_CUT() {
  ADD_APPOINTMENT_TO_DB
}

CHILDRENS_CUT() {
  ADD_APPOINTMENT_TO_DB
}

WOMANS_CUT() {
  ADD_APPOINTMENT_TO_DB
}

PERMANENT_FUNC() {
  ADD_APPOINTMENT_TO_DB
}

CLEANING_AND_DRYING() {
  ADD_APPOINTMENT_TO_DB
}


MAIN_MENU

case $SERVICE_ID_SELECTED in
  1) HIGHLIGHTING_FUNC ;;
  2) BLEACHING_FUNC ;;
  3) MENS_CUT ;;
  4) CHILDRENS_CUT ;;
  5) WOMANS_CUT ;;
  6) PERMANENT_FUNC ;;
  7) CLEANING_AND_DRYING ;;
  *) MAIN_MENU "Please enter a valid option." ;;
esac