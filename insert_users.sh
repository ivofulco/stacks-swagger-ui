#!/bin/bash

API_URL="http://localhost:3000/users"

for i in {1..30}
do
  FIRST_NAME="User$i"
  LAST_NAME="Test"
  BIRTHDAY="199${RANDOM:0:1}-0$((RANDOM%9+1))-0$((RANDOM%9+1))"

  curl -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -d "{\"firstName\": \"$FIRST_NAME\", \"lastName\": \"$LAST_NAME\", \"birthday\": \"$BIRTHDAY\"}"

  echo "Inserted User: $FIRST_NAME $LAST_NAME"
done

echo "✅ 30 Users Inserted!"
