# Boot Device

This is an assembly code to build a disk image that contains a program in the boot segment for BIOS to execute

## Build the boot loader

``` bash
$ nasm -f bin -o boot.bin boot.asm
```

## Build the kernel

``` bash
$ gcc -ffreestanding -m32 -c kernel.c -o kernel.o -fno-pie # compile kernel
$ ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary -m elf_i386 # link kernel
```

## Put images together

```bash
$ cat boot.bin kernel.bin > image.bin
```

## Run the boot loader as the disk

``` bash
$ qemu-system-i386 -fda image.bin
```

## Doc reference
https://www.cs.bham.ac.uk//~exr/lectures/opsys/10_11/lectures/os-dev.pdf