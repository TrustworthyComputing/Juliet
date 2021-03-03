#!/bin/bash
filename="preAux.txt"
while read -r line || [[-n "$line" ]]; do
    ./preprocessor $line
done < "$filename"
