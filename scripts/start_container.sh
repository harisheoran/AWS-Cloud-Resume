#!/bin/bash

################################
# Author: Harish Sheoran
# Purpose: To start the container
# Date: March 16th, 2024
# Version: v1
################################

set -e

docker container run -d -p 4000:4000 --name view_tracker_container --env-file /home/ubuntu/.env harisheoran/view_api_img