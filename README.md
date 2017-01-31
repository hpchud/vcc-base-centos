# vcc-base-centos

This is a CentOS-based VCC base image, containing the VCC tool, daemons and service manager entrypoint.

See the `vcc-torque` and the `vcc-hadoop` repositories for the sample applications that are built on this base image.

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

