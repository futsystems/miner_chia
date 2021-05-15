#!/bin/bash

cat $1 | egrep 'Total time|Copy time'
exit 0
