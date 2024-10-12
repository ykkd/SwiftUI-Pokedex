#!/usr/bin/env sh

# Configuration
XCODE_TEMPLATE_DIR=$HOME'/Library/Developer/Xcode/Templates/File Templates/Custom'
FILE_TEMPLATE_DIR="$XCODE_TEMPLATE_DIR""/Templates/Swift File(Swift Package Support).xctemplate"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy Unio file templates into the local Unio template directory
xcodeTemplate () {
  echo "==> Copying Xcode file templates..."

  if [ -d "$XCODE_TEMPLATE_DIR" ]; then
    rm -R "$XCODE_TEMPLATE_DIR"
  fi
  mkdir -p "$XCODE_TEMPLATE_DIR"

  cp -R $SCRIPT_DIR"/Templates/Swift File(Swift Package Support).xctemplate" "$XCODE_TEMPLATE_DIR"
}

xcodeTemplate

echo "==> ... success!"

