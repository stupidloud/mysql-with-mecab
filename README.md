# MySQL with MeCab Docker Image

[简体中文](README.cn.md)

[![Docker Image CI](https://github.com/stupidloud/mysql-with-mecab/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/stupidloud/mysql-with-mecab/actions/workflows/docker-publish.yml)

This repository contains the necessary files to build a Docker image based on `mysql:8.4-debian` that includes the [MeCab](https://taku910.github.io/mecab/) Full-Text Parser Plugin. This allows for Japanese full-text searching capabilities within MySQL.
## Prerequisites

*   [Docker](https://docs.docker.com/get-docker/) installed on your system.

## Building the Image Locally

1.  Clone this repository:
    ```bash
    git clone https://github.com/stupidloud/mysql-with-mecab.git
    cd mysql-with-mecab
    ```
2.  Build the Docker image:
    ```bash
    docker build -t mysql-mecab:latest .
    ```
    *(Note: The first build might take a while as it needs to download the MySQL source code and compile the plugin.)*

## Using the Image

You can use this image like any other MySQL image. Here's an example using `docker run`:

```bash
docker run --name some-mysql-mecab -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql-mecab:latest
```

Or in a `docker-compose.yml` file:

```yaml
services:
  db:
    image: mysql-mecab:latest # Use the locally built image or replace with your published image (e.g., your-dockerhub-username/mysql-mecab:latest)
    container_name: mysql_with_mecab
    environment:
      MYSQL_ROOT_PASSWORD: your_root_password
      MYSQL_DATABASE: your_database
      MYSQL_USER: your_user
      MYSQL_PASSWORD: your_password
    volumes:
      - ./mysql_data:/var/lib/mysql
    ports:
      - "3306:3306"
    restart: always
```

When MySQL service starts, the MeCab plugin is automatically loaded (via the `plugin-load` configuration). You can verify the installation by connecting to the MySQL instance and running:

```sql
SHOW PLUGINS LIKE 'mecab';
```

## Automated Builds (GitHub Actions)

## Files

*   `Dockerfile`: Defines the multi-stage build process for the image.
*   `mecab.cnf`: MySQL configuration file that uses the `plugin-load` parameter to automatically load the MeCab plugin when the server starts.
