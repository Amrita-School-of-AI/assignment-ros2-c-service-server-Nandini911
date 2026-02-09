#!/bin/bash

# 1. Source the ROS 2 environment
source /opt/ros/jazzy/setup.bash

# 2. Source the local workspace (if it was built)
if [ -f install/setup.bash ]; then
  source install/setup.bash
else
  echo "❌ Error: install/setup.bash not found. Did the build fail?"
  exit 1
fi

# 3. Start the service server in background
echo "Starting service server..."
ros2 run ros2_service_server add_two_ints_server > server_output.log 2>&1 &
SERVER_PID=$!
sleep 3

# 4. Check if service is available
echo "Checking if service is available..."
ros2 service list | grep -q "add_two_ints"
if [ $? -ne 0 ]; then
  echo "❌ Service 'add_two_ints' not found"
  kill $SERVER_PID 2>/dev/null || true
  exit 1
fi
echo "✅ Service is available"

# 5. Call the service and capture output
echo "Calling service with a=5, b=3..."
RESULT=$(ros2 service call /add_two_ints example_interfaces/srv/AddTwoInts "{a: 5, b: 3}" 2>&1)

# 6. Kill the server
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true

# 7. Check the result
echo "Service response: $RESULT"
if echo "$RESULT" | grep -q "sum=8"; then
  echo "✅ Service returned correct sum (8)"
  exit 0
else
  echo "❌ Service did not return correct sum"
  echo "Expected sum=8"
  echo "Server output:"
  cat server_output.log
  exit 1
fi
