#!/bin/sh

echo "licensePlist"

# CI上でPathの参照に失敗するため
if ! "${CI}"; then
	SPM_CLI_COMMON_PATH="${PROJECT_DIR}/../Tools/Common/.build/release"
	xcrun --sdk macosx ${SPM_CLI_COMMON_PATH}/mint run mono0926/LicensePlist license-plist \
	--output-path ${PROJECT_DIR}/${PRODUCT_NAME}/Settings.bundle \
	--mintfile-path ${PROJECT_DIR}/../Mintfile \
	--package-path ${PROJECT_DIR}/../Packages/AppPackage/Package.swift \
	--xcodeproj-path ${PROJECT_DIR}/${PRODUCT_NAME}.xcodeproj
fi
