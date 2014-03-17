# This file bootstraps the products data on Parse for the Parse Store app.
# You should replace PARSE_APP_ID and PARSE_REST_KEY with the ones from your own app.

PARSE_APP_ID=
PARSE_REST_KEY=

RESPONSE=$(curl --silent --request POST \
  --header "X-Parse-Application-Id: $PARSE_APP_ID" \
  --header "X-Parse-REST-API-Key: $PARSE_REST_KEY" \
  --header "Content-Type: image/png" \
  --data-binary '@tshirt.png' \
  https://api.parse.com/1/files/tshirt.png)

FILE_NAME=$(echo $RESPONSE | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')

curl --silent --request POST \
  --header "X-Parse-Application-Id: $PARSE_APP_ID" \
  --header "X-Parse-REST-API-Key: $PARSE_REST_KEY" \
  --header "Content-Type: application/json" \
  --data '{
        "name": "Tshirt",
        "description": "Black T-shirt",
        "hasSize": true,
        "price": 25,
        "quantityAvailable": 100,
        "image": {
          "name": "'$FILE_NAME'",
          "__type": "File"
        }
      }' \
  https://api.parse.com/1/classes/Item

RESPONSE=$(curl --silent --request POST \
  --header "X-Parse-Application-Id: $PARSE_APP_ID" \
  --header "X-Parse-REST-API-Key: $PARSE_REST_KEY" \
  --header "Content-Type: image/png" \
  --data-binary '@hoodie.png' \
  https://api.parse.com/1/files/hoodie.png)

FILE_NAME=$(echo $RESPONSE | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')

curl --silent --request POST \
  --header "X-Parse-Application-Id: $PARSE_APP_ID" \
  --header "X-Parse-REST-API-Key: $PARSE_REST_KEY" \
  --header "Content-Type: application/json" \
  --data '{
        "name": "Hoodie",
        "description": "Black Hoodie",
        "hasSize": true,
        "price": 45,
        "quantityAvailable": 100,
        "image": {
          "name": "'$FILE_NAME'",
          "__type": "File"
        }
      }' \
  https://api.parse.com/1/classes/Item

RESPONSE=$(curl --silent --request POST \
  --header "X-Parse-Application-Id: $PARSE_APP_ID" \
  --header "X-Parse-REST-API-Key: $PARSE_REST_KEY" \
  --header "Content-Type: image/png" \
  --data-binary '@mug.png' \
  https://api.parse.com/1/files/mug.png)

FILE_NAME=$(echo $RESPONSE | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')

curl --silent --request POST \
  --header "X-Parse-Application-Id: $PARSE_APP_ID" \
  --header "X-Parse-REST-API-Key: $PARSE_REST_KEY" \
  --header "Content-Type: application/json" \
  --data '{
        "name": "Mug",
        "description": "Signature Mug",
        "hasSize": false,
        "price": 12,
        "quantityAvailable": 100,
        "image": {
          "name": "'$FILE_NAME'",
          "__type": "File"
        }
      }' \
  https://api.parse.com/1/classes/Item
