# 带 MeCab 的 MySQL Docker 镜像

[English](README.md)

[![Docker Image CI](https://github.com/stupidloud/mysql-with-mecab/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/stupidloud/mysql-with-mecab/actions/workflows/docker-publish.yml)

本仓库包含构建 Docker 镜像所需的文件。该镜像基于 `mysql:8.0-debian`，并集成了 [MeCab](https://taku910.github.io/mecab/) 全文解析插件。这使得在 MySQL 中能够进行日语全文搜索。
## 先决条件

*   系统中已安装 [Docker](https://docs.docker.com/get-docker/)。

## 本地构建镜像

1.  克隆本仓库：
    ```bash
    git clone https://github.com/stupidloud/mysql-with-mecab.git
    cd mysql-with-mecab
    ```
2.  构建 Docker 镜像：
    ```bash
    docker build -t mysql-mecab:latest .
    ```
    *（注意：首次构建可能需要一些时间，因为它需要下载 MySQL 源代码并编译插件。）*

## 使用镜像

您可以像使用其他 MySQL 镜像一样使用此镜像。以下是使用 `docker run` 的示例：

```bash
docker run --name some-mysql-mecab -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql-mecab:latest
```

或者在 `docker-compose.yml` 文件中使用：

```yaml
services:
  db:
    image: mysql-mecab:latest # 使用本地构建的镜像，或替换为您发布的镜像（例如：your-dockerhub-username/mysql-mecab:latest）
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

容器启动后，`install-mecab.sql` 脚本将自动运行以安装 MeCab 插件。您可以通过连接到 MySQL 实例并运行以下命令来验证安装：

```sql
SHOW PLUGINS LIKE 'mecab';
```

## 自动构建 (GitHub Actions)

## 文件说明

*   `Dockerfile`: 定义了镜像的多阶段构建过程。
*   `install-mecab.sql`: 在容器启动时执行的 SQL 脚本，用于在 MySQL 中安装 MeCab 插件。