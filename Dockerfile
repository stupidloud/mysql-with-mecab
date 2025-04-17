# 使用官方 MySQL 8.4 Oracle Linux 9 镜像作为基础
FROM mysql:8.4 AS builder

# 设置环境变量
ENV MYSQL_VERSION=8.4

# 安装编译依赖和 MeCab
RUN microdnf -y update && \
    microdnf -y install dnf dnf-plugins-core && \
    dnf config-manager --set-enabled ol9_codeready_builder && \
    microdnf -y install \
        gcc-toolset-12 \
        gcc-toolset-12-gcc \
        gcc-toolset-12-gcc-c++ \
        gcc-toolset-12-binutils \
        gcc-toolset-12-annobin-annocheck \
        gcc-toolset-12-annobin-plugin-gcc \
        make \
        git \
        cmake \
        openssl-devel \
        ncurses-devel \
        libtirpc \
        libtirpc-devel \
        rpcgen \
        pkg-config \
        bison \
        ca-certificates \
        mecab \
        mecab-devel \
        mecab-ipadic \
        mecab-ipadic-EUCJP && \
    microdnf clean all

# 启用 gcc-toolset-12
SHELL [ "/bin/bash", "-c" ]
ENV PATH=/opt/rh/gcc-toolset-12/root/usr/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/rh/gcc-toolset-12/root/usr/lib64:/opt/rh/gcc-toolset-12/root/usr/lib:$LD_LIBRARY_PATH
ENV MANPATH=/opt/rh/gcc-toolset-12/root/usr/share/man:$MANPATH
ENV PKG_CONFIG_PATH=/opt/rh/gcc-toolset-12/root/usr/lib64/pkgconfig:$PKG_CONFIG_PATH

# 获取 MySQL 源码
WORKDIR /usr/src
RUN git clone --depth 1 --branch 8.4 https://github.com/mysql/mysql-server.git mysql-server

# 创建构建目录并配置 CMake，移除调试信息
WORKDIR /usr/src/mysql-server
RUN mkdir build && cd build && \
    cmake .. -D CMAKE_BUILD_TYPE=Release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/src/boost -DWITH_MECAB=system

# 编译 MeCab 插件
WORKDIR /usr/src/mysql-server/build
RUN make -j$(nproc) mecab_parser

# 最终镜像
FROM mysql:8.4

# 复制 MeCab 插件
COPY --from=builder /usr/src/mysql-server/build/plugin_output_directory/libpluginmecab.so /usr/lib64/mysql/plugin/

# 添加 MeCab 插件配置文件
COPY mecab.cnf /etc/mysql/conf.d/

# 安装运行时依赖
RUN microdnf -y update && \
    microdnf -y install \
        mecab \
        mecab-ipadic \
        mecab-ipadic-EUCJP && \
    microdnf clean all

# 基础镜像的 CMD 会启动 mysqld
