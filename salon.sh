#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# Hiển thị tiêu đề
echo -e "\n~~~ CONGRESS SALON ~~~\n"
echo "Welcome to CONGRESS! How can I help you?"

# Hiển thị danh sách dịch vụ lần đầu tiên
SHOW_SERVICES() {
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME; do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

SHOW_SERVICES

while true; do
  echo -e "\nPlease enter the service number:"
  read SERVICE_ID_SELECTED

  VALID_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -n "$VALID_SERVICE_NAME" ]]; then
    break
  else
    SHOW_SERVICES "I could not find that service. Please choose again:"
  fi
done

echo -e "\nEnter your phone number:"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z "$CUSTOMER_NAME" ]]; then
  echo "I don't have a record for that phone number. What's your name?"
  read CUSTOMER_NAME
  $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like your $VALID_SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

echo -e "\nI have put you down for a $VALID_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
