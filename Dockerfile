FROM ubuntu:22.04

ENV DEBIAN_FRONTEND='noninteractive'

WORKDIR /opssat

# This port must be the same as `server_port` in opssat-simagent.c
EXPOSE 10001/tcp

# Install stuff to make QEMU compile
RUN apt-get update -y && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y \
    build-essential flex bison libssl-dev python3 ninja-build git pkg-config meson \
    libglib2.0-dev libpixman-1-dev libcapstone-dev locales qemu-system-data \
    cmake gdb netcat net-tools

# RUN echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

COPY . .

WORKDIR /opssat/build
# Build QEMU
RUN ../configure --target-list=avr32-softmmu
RUN make -j 8


WORKDIR /opssat
RUN ./build/avr32-softmmu/qemu-system-avr32 --help

# Start the OPS-Sat emulation
CMD ./build/avr32-softmmu/qemu-system-avr32 \
    -machine nanomind-a3200 \
    -bios FIRMWARE_IMAGE_PATH \
    -drive file=FLASH0_IMAGE,format=raw -drive file=FLASH1_IMAGE,format=raw\
    -nographic
