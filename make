#!/bin/bash

# program to compile assembly program
# program also work for linking two file

# check argc
if [ $# -lt 1 ]
then
    echo "Usage: $0 <src> [file ...]"
    exit 1
fi

#directories
readonly BIN="bin"
readonly OBJ="obj"

# parse files
read -ra files <<< ${@:1}

# parse names: filename without extensions
names=()
for file in ${files[@]}
do
    IFS='.' read -ra parts <<< $file
    names+=("${parts[0]}")
done

# for linking
object_files=()

# compile each to object file
for name in ${names[@]}
do
    src_file="$name.asm"
    obj_file="./$OBJ/$name.o"
    object_files+=("$obj_file")

    eval "nasm -f elf32 -o $obj_file $src_file"
    if [ $? -ne 0 ]
    then
        echo "Failed to compile: $src_file"
        exit 1
    fi
done

# linking files
executable="./$BIN/${names[0]}"
eval "ld -m elf_i386 -o $executable ${object_files[@]}"
if [ $? -ne 0 ]
then
    echo "Linking failed!"
    exit 1
fi

eval "$executable"
