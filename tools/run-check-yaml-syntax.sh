#!/bin/bash

### Temp docker syntax checker script. Doesnt really check something...
set -e
for file in $(find . -name '*.yaml'); do
    yamllint -d relaxed $file
done
