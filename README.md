# Summary

This project is closely following the tutorial/guide in the following youtube video series:
* Part1: https://www.youtube.com/watch?v=FkrpUaGThTQ
* Part2: https://www.youtube.com/watch?v=wz9CZBeXR6U

Ths point of this project is for me to learn some basics for creating your own Operating System,
even if it mostly concerns just setting up the bootloader and not much more past that,
but I guess We will see how the project and code in this repository progresses.

# Pre-requisites
## WSL2

* Install Docker
    * Follow the instructions on this link: https://docs.docker.com/docker-for-windows/wsl/

* Install QEMU which we will use to test run our built kernel/os
    * On WSL install by running ```sudo apt-get install qemu-system-x86```
    * Remember that you will need to setup XLaunch or some other X11 server
      as qemu launches in a linux gui.
      Optionally you can install qemu in windows instead.

# Build and Run

1. Create/Build a docker image/container:
```sh
# <dockerfile dir> = Path to directory where our docker file exists
# <tagname> = Some appropriate name used to reference this image at later points
# docker build <dockerfile dir> -t <tagname>
docker build buildenv -t myos-buildenv
```
* You don't need to do this everytime you build. All docker images you build with the ```docker build``` command are cached on your computer and you can list to see which you have with ```docker images```.

2. Run the docker image just built in interactive mode
```sh
# ---- OPTIONS USED ----
# --rm = Remove/Delte the container instance after it finished running. See when and why its good: https://stackoverflow.com/questions/49726272/docker-run-why-use-rm-docker-newbie
# -it = Combination of two options '-i' and '-t'.
#    -i = interactive, stay inside the container so you can keep interacting with it via STDIN
#    -t = Allocate a Pseudo-tty, This linke provides a explanation: https://stackoverflow.com/questions/30137135/confused-about-docker-t-option-to-allocate-a-pseudo-tty
# -v = Bind mount a volume. Mount a folder between the container and host environment. Host is the your OS from where you are starting the container.
# ---- PLACEHOLDERS ----
# <host dir> = Path to directory for mount bind on host side
# <container dir> = Path to directory for mount bind on container side
# <image> = Tag name of a previously built/created docker image.
# docker run --rm -it -v <host dir>:<container dir path> <image>
docker run --rm -it -v $PWD:/root/env myos-buildenv
```

3. Now from inside the container (since we ran with interactive mode, option -i) run:
```make build-x86_64```

4. Now we should have muiltiple build files as a result, in
   perticular our *.iso file, which with current Makefile
   setup should be located at ```dist/x86_64/kernel.iso```

   So now we can test run it in qemu.
   Run the following (assuming current dit is root of our repository): ```qemu-system-x86_64 -cdrom dist/x86_64/kernel.iso```

   You need to have some X11 server, for example XLaunch for this to
   work, as qemu starts linux gui.
   If you have trouble getting it started, as an alternative you can
   just install qemu for your windows instead, and when you launch
   you point out our *.iso file to boot in the exact same way.
