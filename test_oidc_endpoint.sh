#!/usr/bin/env bash

echo "emulate react app call to keycloak"

USER_NAME=niko
PASSWORD=openshift

SSO_REALM_URL="http://localhost:7080/auth/realms/basic"

if [ "X$1" == "X" ] ; then
     echo
else 
     SSO_REALM_URL=$1
fi


echo "using ream url: ${SSO_REALM_URL}"

export access_token=$(\

    curl -kv "${SSO_REALM_URL}/protocol/openid-connect/token" \
    -H 'content-type: application/x-www-form-urlencoded' \
    -d "grant_type=password&username=$USER_NAME&password=$PASSWORD&client_id=curl" | jq --raw-output '.access_token' \
)


test_reports(){
  curl -v -X GET \
 localhost:8000/users/me/items/  -H "Authorization: Bearer ${access_token}"
}

echo "access_token: $access_token"
test_reports
