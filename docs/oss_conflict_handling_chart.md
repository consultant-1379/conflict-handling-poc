# OSS Conflict Handling Chart

[TOC]

## Introduction
This document describes the OSS Conflict Handling Chart - eric-oss-conflict-handling.
It is a Helm 3 chart structure which means that there is no requirements.yaml file - dependencies are described within the Chart.yaml.

## Structure
The key files can be described as follows:
### Chart.yaml
This file contains the main information to describe the Chart which includes the versioning, dependencies, name etc.
### Values.yaml
This file contains the configurable values that are available for this Chart. It also contains any overwritten values from lower level dependencies.
### Values.schema.json
This file contains the rules which the exposed values from this chart must align to.
It ensures that required fields are given to the install as well as ensuring that they follow the required format/syntax.
### Templates
This directory contains templates that are deployed from this Chart level.
It includes secrets, network policies, ingresses etc.

## Site Values
The sample site values file is available at the root of this repo.
In order to install this chart you must fill in the site_values as described below:

## Parameters

| Parameter Name               | Description                                                                   | Example                     |
|------------------------------|-------------------------------------------------------------------------------|-----------------------------|
| global.registry.url          | URL for the Docker Registry to be used for pulling images                     | armdocker.rnd.ericsson.se   |
| global.support.ipv6.enabled  | Enable IPv6 Support within the applications                                   | true                        |
| global.timezone              | Overwrite the timezone to be used in the applications                         | UTC                         |

## Usage
The chart can be installed and upgraded using either helm or Deployment Manager.
In order to install using helm you can use the command below -

```bash
helm install --wait --timeout=720 ./charts/eric-oss-conflict-handling -f sample-site-values.yaml
```
