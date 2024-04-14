#!/bin/bash
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:80)
if [ "$response" -eq 200 ]; then
  echo "HTTP status test passed!"
else
  echo "HTTP status test failed!"
  exit 1
fi

content=$(curl -s http://localhost:80)
if [[ "$content" == *"Hello and welcome to MadsBlog test site!"* ]]; then
  echo "Content test passed!"
else
  echo "Content test failed!"
  exit 1
fi
