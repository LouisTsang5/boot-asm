# Boot Device

This is an assembly code to build a disk image that contains a program in the boot segment for BIOS to execute

## Build Binary

``` bash
$ nasm -f bin -o disk.bin disk.asm
```

## Run Disk

``` bash
$ qemu-system-i386 -fda disk.bin
```