#!/bin/bash

echo "Enter package name:"
read package_name

mkdir -p "Packages/$package_name"

cd "Packages/$package_name" && \
swift package init --type library --enable-swift-testing --name $package_name