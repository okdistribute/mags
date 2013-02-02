#!/bin/bash

#AUTHOR: Christopher Zakian | czakian@indiana.edu
#a small testing script for trying out and individual student on the autograder

stu_hash=864376186e9f5809d9d4dae40975ced395cc881a
#stu_hash=7dceea5112c5d98300ccab213279a6bc8488009a
username=eamsden
sol_hash=68460cc3b09b3cd59b20074fd6010757956d35c0
#sol_hash=7ee3bf7fff71f2fa0d1919ef60ea9b73bef219b5

./p423_autograder.py "test_suite" $sol_hash $username/$stu_hash

