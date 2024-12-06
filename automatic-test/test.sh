#!/bin/bash

# Variables
BASE_URL="http://mb-webapp34284-dev.azurewebsites.net/api/translate"
CONTENT_TYPE="application/json"
TRANSLATOR_API="azure"
AZURE_ENDPOINT="https://api.cognitive.microsofttranslator.com/"
AZURE_CREDENTIALS="bccaadcc92794b6994ae0baa9"
TEST_URL="https://madsblog.net/2024/10/29/kubernetes-networking-parte-2/"
LOOP_COUNT=10  # Number of requests to send
DELAY=1  # Delay in seconds between requests

# Loop to send traffic
for ((i=1; i<=LOOP_COUNT; i++)); do
  echo "Sending request $i to $BASE_URL"
  
  curl -i -w '\n' -X POST "$BASE_URL" \
    -H "Content-Type: $CONTENT_TYPE" \
    -d '{
      "url": "'"$TEST_URL"'",
      "translator_api": "'"$TRANSLATOR_API"'",
      "azure_endpoint": "'"$AZURE_ENDPOINT"'",
      "azure_credentials": "'"$AZURE_CREDENTIALS"'"
    }'
  
  echo "Request $i sent."
  
  # Delay between requests
  sleep $DELAY
done
