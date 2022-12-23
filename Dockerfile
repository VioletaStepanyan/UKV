FROM --platform=$BUILDPLATFORM crazymax/osxcross:11.3-ubuntu as osxcross
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# https://github.com/crazy-max/docker-osxcross#build
# https://github.com/tonistiigi/xx/
# docker buildx build --no-cache --platform=darwin/amd64 --file ./Dockerfile . --progress=plain -c 32

FROM --platform=$BUILDPLATFORM ubuntu as builder
COPY --from=xx / /
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
ENV PATH="/osxcross/bin:$PATH"
ENV LD_LIBRARY_PATH="/osxcross/lib:$LD_LIBRARY_PATH"

RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split && \
    ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb && \
    ln -s /bin/rm /usr/sbin/rm && \
    ln -s /bin/tar /usr/sbin/tar && \
    ln -s /bin/as /usr/sbin/as

RUN apt-get update -y && \
    apt-get install -y apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" && \
    apt-get install -y --no-install-recommends cmake git libssl-dev build-essential zlib1g zlib1g-dev python3 python3-dev clang lld libc6-dev

COPY . /usr/src/ukv
WORKDIR /usr/src/ukv

RUN git config --global http.sslVerify "false"
RUN --mount=type=bind,from=osxcross,source=/osxcross,target=/osxcross CC=o64-clang CXX=o64-clang++ \
    cmake \
        -DUKV_BUILD_TESTS=0 \
        -DUKV_BUILD_BENCHMARKS=0 \
        -DUKV_BUILD_ENGINE_UMEM=1 \
        -DUKV_BUILD_ENGINE_LEVELDB=1 \
        -DUKV_BUILD_ENGINE_ROCKSDB=1 \
        -DUKV_BUILD_API_FLIGHT_CLIENT=0 \
        -DUKV_BUILD_API_FLIGHT_SERVER=1 . && \
        make -j32 \
            ukv_flight_server_umem \
            ukv_flight_server_leveldb \
            ukv_flight_server_rocksdb

# ## TODO: Optimize: https://github.com/docker-slim/docker-slim
# FROM ubuntu:focal
# WORKDIR /root/

# COPY --from=builder /usr/src/ukv/build/bin/ukv_flight_server_umem ./umem_server
# # ADD ./assets/config_umem.json /var/lib/ukv/umem/config_umem.json

# COPY --from=builder /usr/src/ukv/build/bin/ukv_flight_server_leveldb ./leveldb_server
# # ADD ./assets/config_leveldb.json /var/lib/ukv/leveldb/config_leveldb.json

# COPY --from=builder /usr/src/ukv/build/bin/ukv_flight_server_rocksdb ./rocksdb_server
# # ADD ./assets/config_rocksdb.ini /var/lib/ukv/rocksdb/config_rocksdb.ini

# EXPOSE 38709
# CMD ["./umem_server"]
