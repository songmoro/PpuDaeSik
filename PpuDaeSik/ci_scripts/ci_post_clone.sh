#!/bin/bash

brew install tuist
tuist version

cd PpuDaeSik

tuist clean
tuist generate --no-open
