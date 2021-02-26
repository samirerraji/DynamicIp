#!/bin/bash
docker run --name dynamicip  --mount type=bind,source=/home/grumsh/git/DynamicIp/.aws,target=/root/.aws -i --rm grumsh/dynamicip