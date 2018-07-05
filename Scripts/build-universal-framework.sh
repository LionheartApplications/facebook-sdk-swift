#!/bin/sh

UNIVERSAL_OUTPUT_FOLDER="$2"

# make the output directory and delete the framework directory
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/$1.framework"

# Step 1. Build Device and Simulator versions
xcodebuild -target "$1" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
xcodebuild -target "$1" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 2. Copy the framework structure to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$1.framework" "${UNIVERSAL_OUTPUT_FOLDER}/"

# Step 3. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUT_FOLDER}/$1.framework/$1" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/$1.framework/$1" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$1.framework/$1"

