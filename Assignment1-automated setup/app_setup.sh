#!/bin/bash -x

scp -r setup/ todoapp:
ssh todoapp bash setup/install_script.sh
