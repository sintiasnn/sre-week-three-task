#!/bin/bash

# Define variables
NAMESPACE="sre"

DEPLOYMENT_NAME="swype-app"

MAX_RESTARTS=3

# Infinite loop for monitoring
while true; do

  # Get pod restarts
  POD_RESTARTS=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME --no-headers -o wide | awk '{print $4}')
  # Display current restart count
  echo "Current restart count for $DEPLOYMENT_NAME: $POD_RESTARTS"

  # Check restart limit
  if [[ $POD_RESTARTS -gt $MAX_RESTARTS ]]; then
    echo "Deployment $DEPLOYMENT_NAME exceeded restart limit ($MAX_RESTARTS). Scaling down..."
    kubectl scale deployments/$DEPLOYMENT_NAME --replicas=0 -n "$NAMESPACE"
    break
  fi

  # Pause for 60 seconds
  sleep 60
done

echo "Monitoring stopped."