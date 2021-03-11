#!/usr/bin/env bash
node -p 'require("isolated-vm")'
ls -allh node_modules/isolated-vm/out/
cp -f node_modules/isolated-vm/out/isolated_vm.node "$(node ./get-filename)"