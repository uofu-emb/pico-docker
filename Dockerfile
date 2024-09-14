FROM debian:bookworm

ADD --checksum=sha256:28cb203223956e467b527fec5146d05de1128812a6aebb0ad312a0d375b3b1d6 \
    https://github.com/renode/renode/releases/download/v1.15.2/renode_1.15.2_amd64.deb /tmp
RUN apt-get update && \
    apt-get install -y \
        build-essential pkg-config libusb-1.0-0-dev gcc-arm-none-eabi \
	cmake python3 python3-pip robot-testing-framework openocd  && \
    apt install -y /tmp/renode_1.15.2_amd64.deb && \
    rm -rf /var/lib/apt/lists/* /tmp/renode*

ADD https://github.com/raspberrypi/pico-sdk.git#2.0.0 /usr/local/share/pico-sdk
ADD https://github.com/ThrowTheSwitch/Unity.git#v2.6.0 /usr/local/share/unity
ADD https://github.com/FreeRTOS/FreeRTOS-Kernel.git#V11.1.0 /usr/local/share/freertos
ENV PICO_SDK_PATH /usr/local/share/pico-sdk
ENV FREERTOS_PATH /usr/local/share/freertos
ENV UNITY_PATH /usr/local/share/unity
ENV PICO_TOOLCHAIN_PATH /usr/bin

ADD https://github.com/raspberrypi/picotool.git#2.0.0 /tmp/picotool
RUN cd /tmp/picotool && \
    cmake -B build . && \
    cmake --build build && \
    cmake --install build && \
    mkdir -p /etc/udev/rules.d && \
    cp udev/99-picotool.rules /etc/udev/rules.d/ && \
    rm -rf /tmp/picotool

COPY rp2040_divider.py /opt/renode/scripts/pydev
COPY rp2040_spinlock.py /opt/renode/scripts/pydev
COPY rpi_pico_rp2040_w.repl /opt/renode/platforms/cpus