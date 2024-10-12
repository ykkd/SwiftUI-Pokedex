#!/bin/bash

echo "Enter package name:"
read package_name

mkdir -p "Pacakges/$package_name"

cd "Pacakges/$package_name" && \
swift package init --type library --enable-swift-testing --name $package_name