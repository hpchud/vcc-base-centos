# vcc-base-centos

This is the CentOS 7 base image.

It is built using the [vcc](https://github.com/hpchud/vccjs) framework and uses the systemd service manager.

## Purpose of this image

Typically, you would use this as a base for your own parallel container.

When you run multiple instances of a container based on this image, linked together via a common discovery service, they will establish host/machine files and SSH keys automatically. You can dynamically add or remove containers and these services will be updated automatically.

See [vcc-torque](https://github.com/hpchud/vccjs) for an example that models a PBS/Torque batch scheduling cluster.

## Building

Just build as any other Docker image

```
docker build -t hpchud/vcc-base-centos .
```

If you need to specify a proxy, use build time arguments

```
docker build -t hpchud/vcc-base-centos \
    --build-arg http_proxy=http://proxy-server:3128 \
    --build-arg https_proxy=http://proxy-server:3128 \
    .
```