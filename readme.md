# Boot Device

This is an assembly code to build a disk image that contains a program in the boot segment for BIOS to execute

## Build the boot loader

``` bash
$ nasm -f bin -o boot.bin boot.asm
```

## Run the boot loader as the disk

``` bash
$ qemu-system-i386 -fda boot.bin
```

## Doc reference
https://www.cs.bham.ac.uk//~exr/lectures/opsys/10_11/lectures/os-dev.pdf