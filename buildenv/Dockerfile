# Following 3 lines taken from: https://hub.docker.com/r/randomdude/gcc-cross-x86_64-elf
FROM randomdude/gcc-cross-x86_64-elf

RUN apt-get update
RUN apt-get upgrade -y

# Allows us to compile our assembly code
RUN apt-get install -y nasm

# Needed to build our final .iso file
RUN apt-get install -y xorriso
RUN apt-get install -y grub-pc-bin
RUN apt-get install -y grub-common

# Create a mount point that maps to the folder '/root/env' inside our docker container
VOLUME /root/env
# Make this folder our starting point when running 'docker run'
WORKDIR /root/env
