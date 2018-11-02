Docker
======

Docker containers are run via two different mechanisms on *Conductor*:

* Docker Compose
* Docker Swarm

## Service Orchestration

Most services should be run under *Docker Swarm*, however *Docker Swarm* is unable to dynamically build images on the fly from the *Dockerfile*. Hosting all built images in a remote registry (e.g. *Docker Hub*) is not viable due to cost and limited connectivity from the RV.

*Docker Compose* is therefore used solely to host a registry, and all other services are managed by *Docker Swarm*.

### Docker Compose

#### Registry

Using the official image, a private registry is exposed on port 5000.

### Docker Swarm

All regular services are managed by *Docker Swarm*. These include:

* InfluxDB `(port 8086)`
* Mosquitto `(ports 1883, 9001)`
* NodeRED `(port 1880)`

## Secrets