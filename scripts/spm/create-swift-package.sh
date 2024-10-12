#!/bin/bash

echo "Enter package name:"
read package_name

mkdir -p "$package_name"

cd $package_name && \
swift package init --type library --enable-swift-testing --name $package_name && \
swift build && \
mkdir -p ".swiftpm/xcode/package.xcworkspace/xcshareddata/"

# cd $package_name && \
# swift package init --name $package_name --type library --enable-swift-testing --disable-xctest --version && \
# mkdir -p ".swiftpm/xcode/package.xcworkspace/xcshareddata/"

# cat << EOF > "$package_name/.swiftpm/xcode/package.xcworkspace/xcshareddata/IDETemplateMacro.plist"
# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>
#     <key>PACKAGENAME</key>
#     <string>$package_name</string>
#     <key>FILEHEADER</key>
#     <string>
# //  ___FILENAME___
# //  ___PACKAGENAME___
# //
# //  Created by ___FULLUSERNAME___ on ___DATE___.
# //</string>
# </dict>
# </plist>
# EOF

# echo "Created Swift Package named: '$package_name' and IDETemplateMacro.plist"