Conductor
=========

*Conductor* manages all data within the RV - capturing, storing, processing and archiving. It does this by running a number of different services, each with a specific responsibility.

All these services run in **Docker** using `docker-compose` to orchestrate them. All data is stored in mounted volumes so that the host processes are otherwise stateless - in other words, if the machine dies, it can be quickly re-imaged and restored with no data loss.

The *Conductor* itself is headless, but exposes a number of APIs and web endpoints that other devices may connect to.

## Table of Contents

1. Hardware
1. Architecture
   * Security
   * Credentials Vault
   * Authentication
1. Installation

## Hardware

*Conductor* runs on a Raspberry Pi 3 or above. To avoid reliability issues caused by long-term use of SD cards, an external drive, preferably SSD, should be used.

To enable boot from USB, follow the [instructions](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/msd.md) on the Raspberry Pi website.

The following hardware is required:

* Raspberry Pi 3 or 3+ (if 3 then enable USB boot as per above)
* External USB drive (SSD preferred)

## Architecture

The Operating System is Raspbian Stretch Lite, based on Debian Stretch. The only software installed directly on the OS are:

* Docker
* Docker Compose
* Git

This repository contains the `docker-compose.yml` file that defines the services that run as *Docker* containers.

> Note: The Raspberry Pi has an ARMv7 processor so all *Docker* containers must be ARM variants. There is nothing otherwise stopping *Conductor* from being run on a different host.

### Security

*Conductor* must be provisioned with a private SSH key that allows it access to remote servers as a trusted client. These include use cases such as:

* Pulling this repository from GitHub
* Remotely connecting to other servers for data transfer
* Decrypting the credentials vault

### Credentials Vault

All credentials that *Conductor* needs are stored in the *Credentials Vault*. This is an encrypted file stored within this repository. It is encrypted using a private SSH key that is stored separately and must be manually copied to the *Conductor* machine.

## Installation

1. Download & Flash microSD Card
1. Enable SSH and WiFi
1. Boot the Raspberry Pi
1. Import Your SSH Public Key
1. Run `raspi-config`
1. Run Install Script
   * Create conductor user and lock down SSH access
   * Add Conductor private SSH key to Raspberry Pi
   * Install Docker, Docker Compose and Git

### Download & Flash microSD Card

Download Raspbian Stretch Lite from the [Raspberry Pi](https://www.raspberrypi.org/downloads/raspbian/) website.

Use [Etcher](https://etcher.io) to write the image to the USB drive.

### Enable SSH and WiFi

Copy the files from this repository in `./raspberry-pi/boot/` into the `boot` partition on your newly imaged USB drive.

The presence of the empty `ssh` file will trigger the Raspberry Pi to enable the SSH service. Initially this will be password only but the install scripts will modify this.

The `wpa_supplicant.conf` file will configure WiFi. Make sure to update the SSID and password in the `wpa_supplicant.conf` file. If you are connecting to Ethernet and don't need WiFi, you can omit copying the `wpa_supplicant` file.

### Boot the Raspberry Pi

If using Ethernet, connect the Ethernet cable to the Raspberry Pi. Connect the USB drive to one of the Raspberry Pi's USB ports. Connect the Raspberry Pi to power via its micro USB connector. It will boot automatically.

By default, the hostname is `raspberrypi.local`. In case this doesn't work, either check the router or plug the Raspberry Pi into a monitor and it will show the IP address on the screen.

### Import Your SSH Public Key

From your local machine, execute the following command, replacing the IP address with that of the Raspberry Pi.

```sh
ssh-copy-id pi@raspberrypi.local
```

When asked `Are you sure you want to continue connecting (yes/no)?`, enter `yes`.

When prompted for a password, enter the default: `raspberry`

### Run Install Script

Connect to the Raspberry Pi via SSH, now using the same user as you just copied the public key across for.

```sh
ssh pi@raspberrypi.local "curl -sSL https://github.com/abstractvector/conductor/blob/master/raspberry-pi/install.sh | sh"
```

This may take a few minutes but will complete the configuration of the Raspberry Pi, including installation of all software and services. The Raspberry Pi will reboot after the install completes.