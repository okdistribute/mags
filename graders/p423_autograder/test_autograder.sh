#!/bin/bash

#AUTHOR: Christopher Zakian | czakian@indiana.edu
#a small testing script for trying out and individual student on the autograder

stu_hash=6671953a66c6873c0440afc161448071409a400f
username=zgoldman
sol_hash=cd0a1a256b283013fe899c664277de03fb684316
opts=all
cmd=scheme-xml

./p423_autograder.py N/A $sol_hash $username/$stu_hash $opts $cmd 

