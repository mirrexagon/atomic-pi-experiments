# Atomic Pi Experiments

## Links

### Official pages
- https://digital-loggers.com/api.html
- http://www.digital-loggers.com/api_faqs.html

### Unofficial BIOS images
- http://ehxz.tk/apibios

## BNO055
SoC I2C bus I2C2 has a BNO055 on it. You don't need to set up the pins as GPIO bit-banged I2C as the official Atomic Pi documentation says.

Loading the `i2c-dev` kernel module, something is found by i2cdetect on `/dev/i2c-2` at address 0x28 (using SMBus receive byte command since the quick write command is not available on the SoC I2C buses). That is the bus and address we expect the BNO055 on as per the schematic.


To confirm the presence of the BNO055:
- `modprobe i2c-dev`
- `i2cdetect -r 2`
    - We use `-r` to force using the SMBus receive byte command instead of the quick write command.
