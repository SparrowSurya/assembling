<div align="center">
    <a href='https://github.com/SparrowSurya/assembling.git'><h1>Assembling</h1></a>
    <p><i>Brain Teasing</i></p>
</div>


## Environment
+ **OS**: Linux (WSL:kali-linux distro)
+ **Editor**: Visual Studio Code
+ **Assembler**: nasm
+ **Debugging**: edb-debugger


## Compiling
Mannually:
```sh
nasm -f elf32 -o file.o file.asm
ld -m elf_1386 -o file file.o
./file
```

Script:
```sh
./make file.asm
```
See [make](./make) for more.

