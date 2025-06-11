#!/bin/bash

brew install tuist
tuist version

cd ..

tuist clean
tuist generate --no-open
