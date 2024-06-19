# Lakritz Computer

Lakritz is an FPGA computer designed by Lone Dynamics Corporation.

![Lakritz Computer](https://github.com/machdyne/lakritz/blob/570c8733f1c3a25d6e241fe2c17254a944a328bc/lakritz.png)

This repo contains schematics, PCB layouts, pinouts, a 3D-printable case, example gateware and documentation.

Find more information on the [Lakritz product page](https://machdyne.com/product/lakritz-computer/).

## Programming Lakritz

Lakritz has a JTAG interface and ships with a [DFU bootloader](https://github.com/machdyne/tinydfu-bootloader) that allows the included flash [MMOD](https://machdyne.com/product/mmod) to be programmed over the USB-C port.

### DFU

The DFU bootloader is available for 5 seconds after power-on, issuing a DFU command during this period will stop the boot process until the DFU device is detached. If no command is received the boot process will continue and the user gateware will be loaded.

Install [dfu-util](http://dfu-util.sourceforge.net) (Debian/Ubuntu):

```
$ sudo apt install dfu-util
```

Update the user gateware on the flash MMOD:

```
$ sudo dfu-util -a 0 -D image.bit
```

Detach the DFU device and continue the boot process:

```
$ sudo dfu-util -a 0 -e
```

It is possible to update the bootloader itself using DFU but you shouldn't attempt this unless you have a JTAG programmer (or another method to program the MMOD) available, in case you need to restore the bootloader.

### JTAG

These examples assume you're using a "USB Blaster" JTAG cable, see the header pinout below. You will need to have [openFPGALoader](https://github.com/trabucayre/openFPGALoader) installed.

Program the configuration SRAM:

```
openFPGALoader -c usb-blaster image.bit
```

Program the flash MMOD:

```
openFPGALoader -f -c usb-blaster images/bootloader/tinydfu_lakritz.bit
```

## Blinky 

Building the blinky example requires [Yosys](https://github.com/YosysHQ/yosys), [nextpnr-ecp5](https://github.com/YosysHQ/nextpnr) and [Project Trellis](https://github.com/YosysHQ/prjtrellis).

Assuming they are installed, you can simply type `make` to build the gateware, which will be written to output/blinky.bin. You can then use [openFPGALoader](https://github.com/trabucayre/openFPGALoader) or dfu-util to write the gateware to the device.

## Linux

See the [Kakao Linux](https://github.com/machdyne/kakao) repo for the latest instructions.

### Prebuilt Images

Copy the files from the `images/linux` and `images/v0/25f` directory to the root directory of a FAT-formatted MicroSD card along with the files from the `images` directory in the [Kakao Linux](https://github.com/machdyne/kakao) repo.

Lakritz ships with LiteX gateware on the user gateware section of the MMOD that is compatible with these images. After several seconds the Linux penguin should appear on the screen (HDMI) followed by a login prompt.

### Building Linux

Please follow the setup instructions in the [linux-on-litex-vexriscv](https://github.com/litex-hub/linux-on-litex-vexriscv) repo and then:

1. Build the Linux-capable gateware:

```
$ cd linux-on-litex-vexriscv
$ ./make.py --board lakritz --uart-baudrate 115200 --dcache-size 64 --icache-size 64 --dcache-ways=1 --icache-ways=1 --dtlb-size 2 --itlb-size 2 --build
```

NOTE: This may fail, if so:

```
$ cd build/lakritz/gateware
```

Edit `lakritz.ys` and add the `-abc2` option as shown below:

```
synth_ecp5  -top lakritz -abc2
```

Now run:

```
$ bash build_lakritz.sh
```


2. Write the gateware to the MMOD using USB DFU:

```
$ sudo dfu-util -a 0 -D build/lakritz/gateware/lakritz.bit
```

3. Copy the device tree binary `build/lakritz/lakritz.dtb` to a FAT-formatted MicroSD card.

4. Build the Linux kernel and root filesystem:

```
$ cd ..
$ git clone http://github.com/buildroot/buildroot
$ cd buildroot
$ make BR2_EXTERNAL=../linux-on-litex-vexriscv/buildroot/ litex_vexriscv_usbhost_defconfig
```

Optionally customize the kernel and buildroot packages:

```
$ make menuconfig
```

Build the kernel and rootfs:

```
$ make
$ ls output/images
```

5. Copy the `Image` and `rootfs.cpio` files from output/images to the MicroSD card.

6. Copy the OpenSBI binary (included in this repo as `lakritz/images/linux/opensbi.bin`) to the MicroSD card. Alternatively, you can build this binary by following [these instructions](https://github.com/litex-hub/linux-on-litex-vexriscv#-generating-the-opensbi-binary-optional).

7. Copy `lakritz/images/linux/boot.json` to the MicroSD card.

8. Power-cycle Lakritz. After Linux has finished booting you should see a login prompt on the HDMI display.

## JTAG Header

The 3.3V JTAG header can be used to program the FPGA SRAM as well as the MMOD flash memory. It can also be used to provide power (5V) to the board.

```
2 4 6
1 3 5
```

| Pin | Signal |
| --- | ------ |
| 1 | TCK |
| 2 | TDI |
| 3 | TDO |
| 4 | TMS |
| 5 | 5V0 |
| 6 | GND |

## Resources

 * [fpga-dac audio player](https://github.com/machdyne/fpga-dac)

## Board Revisions

| Revision | Notes |
| -------- | ----- |
| V0 | Initial version |

## License

The contents of this repo are released under the [Lone Dynamics Open License](LICENSE.md) with the following exceptions:

- The KiCad design files contain parts of the [kicad-pmod](https://github.com/mithro/kicad-pmod) library which is released under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0.html).

- The KiCad design files may contain symbols and footprints released under other licenses; please contact us if we've failed to give proper attribution.

Note: You can use these designs for commercial purposes but we ask that instead of producing exact clones, that you either replace our trademarks and logos with your own or add your own next to ours.
