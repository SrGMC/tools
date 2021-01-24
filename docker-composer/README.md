# docker-composer

A Node.js program to organize and sort `docker-compose.yaml` files

## Table of contents

- [docker-composer](#docker-composer)
  - [Table of contents](#table-of-contents)
  - [Dependecies](#dependecies)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Example](#example)

## Dependecies

`docker-composer` uses the following dependencies:

-   [`yaml`](https://www.npmjs.com/package/yaml)

## Installation

Install all dependencies with

```bash
npm i
```

## Usage

`docker-composer` uses Node.js. To orgnanize and sort `docker-compose` files and print the output to `STDOUT`, execute:

```bash
node index [-h] file
```

or

```bash
npm start -- [-h] file
```

A `docker-compose` file is requiered as input in the `file` parameter. The sorted output will be printed to `STDOUT` with the following order rules:

1. `image`
2. `container_name`
3. `depends_on`
4. `network_mode`
5. `networks`
6. `env_file`
7. `environment`
8. `working_dir`
9. `volumes`
10. `labels`
11. `ports`
12. Any other key (no explicit order)
13. `command`
14. `restart`

### Example

See `docker-compose.yaml` as input and `docker-compose-sorted.yaml` as output
