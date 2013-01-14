#!/bin/bash

#AUTHOR: Christopher Zakian | czakian@indiana.edu
#a small testing script for trying out and individual student on the autograder

stu_hash=6671953a66c6873c0440afc161448071409a400f
username=zgoldman
sol_hash=7ee3bf7fff71f2fa0d1919ef60ea9b73bef219b5
opts=all
cmd=scheme

python3 p423_autograder.py $sol_hash $username/$stu_hash $opts $cmd 

