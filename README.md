# MySQL with MeCab Docker Image

[![Docker Image CI](https://github.com/your-github-username/your-repo-name/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/your-github-username/your-repo-name/actions/workflows/docker-publish.yml)

This repository contains the necessary files to build a Docker image based on `mysql:8.0-debian` that includes the [MeCab](https://taku910.github.io/mecab/) Full-Text Parser Plugin. This allows for Japanese full-text searching capabilities within MySQL.

## Prerequisites

*   [Docker](https://docs.docker.com/get-docker/) installed on your system.

## Building the Image Locally

1.  Clone this repository:
    ```bash
    git clone https://github.com/your-github-username/your-repo-name.git
    cd your-repo-name
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
    image: mysql-mecab:latest # Or your published image, e.g., your-dockerhub-username/mysql-mecab:latest
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

After the container starts, the `install-mecab.sql` script will automatically run, installing the MeCab plugin. You can verify the installation by connecting to the MySQL instance and running:

```sql
SHOW PLUGINS LIKE 'mecab';
```

## Automated Builds (GitHub Actions)

This repository includes a GitHub Actions workflow (`.github/workflows/docker-publish.yml`) that automatically builds and pushes the Docker image to Docker Hub whenever changes are pushed to the `main` branch.

**Setup:**

1.  **Customize Image Name:** Before pushing, edit `.github/workflows/docker-publish.yml` and replace all occurrences of `your-dockerhub-username/mysql-mecab` with your desired Docker Hub repository name (e.g., `myusername/mysql-mecab`). Commit this change.
2.  **Configure Secrets:** In your GitHub repository settings (`Settings` -> `Secrets and variables` -> `Actions`), add the following repository secrets:
    *   `DOCKERHUB_USERNAME`: Your Docker Hub username.
    *   `DOCKERHUB_TOKEN`: A Docker Hub Access Token with push permissions. **Do not use your password.**
3.  **Push to GitHub:** Push your local repository to GitHub. The action will trigger automatically.

The workflow will tag the image with `latest` and the Git commit SHA.

## Files

*   `Dockerfile`: Defines the multi-stage build process for the image.
*   `install-mecab.sql`: SQL script executed on container startup to install the MeCab plugin within MySQL.
*   `.github/workflows/docker-publish.yml`: GitHub Actions workflow for automated building and publishing to Docker Hub.