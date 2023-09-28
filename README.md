# QEMU-AVR32 OPS-SAT Emulator

This emulator was used for security research on ESA's OPS-SAT during our work for the [Space Odyssey](https://publications.cispa.saarland/3934/1/SatSec-Oakland22.pdf) academic research paper, published on the 44th IEEE Symposium on Security and Privacy (IEEE S&P / Oakland). The paper describes the details of our findings. The emulator emulates the satellite's bus system consisting of a GomSpace NanoMind A3200 board and is based on the work of Florian Göhler's AVR32 implementation for QEMU: https://github.com/flogosec/qemu-avr32.

## Disclaimer
This project **does not contain satellite firmware**, it is just an emulator that can be used to analyze specific satellite firmware. Unfortunately, we can not provide you with firmware.


## Build Instructions
The easiest way to build and execute the emulator is using the provided Docker file. The emulator exposes a TCP port that can be used to send telecommands (TC) to the emulator and receive back telemetry (TM). There are also ports opened for the UART interface to retrieve logging output on the satellite.

```shell
docker build . -t opssat-test
docker run -p 10001:10001 opssat-test
```

For this to work, you need some satellite firmware first. Building this without firmware will result in an error. You need to provide the following path and the files:
- `FIRMWARE_IMAGE_PATH`: A valid AVR32 binary firmware image compiled with GomSpace's NanoMind A3200
- `FLASH0/1_IMAGE`: There are two flash chips for redundancy that store an uffs filesystem. You need to provide a path to valid images.


## FAQ - Frequently Asked Questions
> Can you provide the OPS-Sat firmware?

No, the OPS-Sat team at ESA was so kind to provide us with the image for our research, under the condition that we don't share it.

> Can this emulator be used for other satellites?

It depends. If they are also using GomSpace's NanoMind A3200 board then it could work (but is untested). Also, the code contains multiple segments that are specific for OPS-SAT (for example, workarounds to fix missing hardware emulations), so you might have to adapt the code to your needs.

> Is this still actively developed?

At the time of writing, development is continued by Florian Göhler in his repository (we recommend you check it out!): https://github.com/flogosec/qemu-avr32. This repository serves as a snapshot of the emulator we have used for our paper.

## Citing the Paper
If you would like to cite our work, please use the following BibTex entry:
```
@inproceedings{willbold2023space,
  title={Space Odyssey: An Experimental Software Security Analysis of Satellites},
  author={Willbold, Johannes and Schloegel, Moritz and V{\"o}gele, Manuel and Gerhardt, Maximilian and Holz, Thorsten and Abbasi, Ali},
  booktitle={IEEE Symposium on Security and Privacy (S\&P)},
  year={2023}
}
```