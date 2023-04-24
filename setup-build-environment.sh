#!/bin/sh
apk add libusb-dev ncurses-dev libffi-dev avrdude gcc-avr binutils-avr avr-libc stm32flash newlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi libusb pkgconfig
chmod +x /klipper/scripts/check-gcc.sh