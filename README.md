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
1. Registry
1. Service Catalog
   * Core
   * Monitoring
   * Smart RV
   * Build Tools
   * Archiving
1. Installation

## Hardware

*Conductor* runs on an Intel NUC8i3BEH with 8GB of RAM and a 256GB Samsung EVO 970 SSD. Network connectivity is available via WiFi.

## Architecture

The Operating System is Ubuntu 18.04 LTS 64-bit. Beyond the default from the OS install, the only software packages installed directly on the machine are:

* Docker
* Docker Compose
* Git

This repository contains the `docker-compose.yml` file that defines the services that run as *Docker* containers.

### Security

*Conductor* must be provisioned with a private SSH key that allows it access to remote servers as a trusted client. These include use cases such as:

* Pulling this repository from GitHub
* Remotely connecting to other servers for data transfer
* Decrypting the credentials vault

### Credentials Vault

All credentials that *Conductor* needs are stored in the *Credentials Vault*. This is an encrypted file stored within this repository. It is encrypted using a private SSH key that is stored separately and must be manually copied to the *Conductor* machine.

## Installation

1. Download & Flash USB drive with Ubuntu 18.04 LTS
1. Boot the Intel NUC
1. Install Ubuntu
1. Import Your SSH Public Key
1. Run Install Script
   * Create conductor user and lock down SSH access
   * Add Conductor private SSH key to Raspberry Pi
   * Install Docker, Docker Compose and Git