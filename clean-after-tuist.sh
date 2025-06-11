#!/bin/bash

echo "Cleaning..."

tuist clean
rm -rf .build
find . -name "*.xcodeproj" -type d -exec rm -rf {} +
rm -rf *.xcworkspace
find . -type d -name "Derived" -exec rm -rf {} +

echo "end"
