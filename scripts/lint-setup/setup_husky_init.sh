#!/bin/bash

# create ~/.config/husky/init.sh if needed
if [ ! -f ~/.config/husky/init.sh ]; then
    mkdir -p ~/.config/husky
    touch ~/.config/husky/init.sh
    echo "created ~/.config/husky/init.sh"
else
    echo "found ~/.config/husky/init.sh"
fi

chmod +x ~/.config/husky/init.sh

# to use husky from sourcetree

node_path=$(dirname $(which node))
echo "export PATH=\"$node_path:\$PATH\"" >> ~/.config/husky/init.sh

npx_path=$(dirname $(which npx))
echo "export PATH=\"$npx_path:\$PATH\"" >> ~/.config/husky/init.sh

echo "completed setup_husky_init.sh "