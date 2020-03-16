#!/bin/bash

for file in ./TestFiles/*
do
    echo $file
    diff --suppress-common-lines -y -W 100 -s <(lexer $file) <(./lexer $file)
done
