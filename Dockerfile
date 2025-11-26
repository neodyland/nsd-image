FROM ubuntu:24.04 AS src

WORKDIR /src
RUN apt-get update && apt-get install -y wget tar
RUN wget https://nlnetlabs.nl/downloads/nsd/nsd-4.13.0.tar.gz
RUN tar -xf nsd-4.13.0.tar.gz

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y build-essential \
    libevent-dev \
    libssl-dev \
    bison \
    flex \
    pkg-config \
    libsystemd-dev \
    libprotobuf-c-dev \
    protobuf-compiler \
    protobuf-c-compiler \
    libfstrm-dev

WORKDIR /build
COPY --from=src /src/nsd-4.13.0 /build/nsd

WORKDIR /build/nsd
RUN ./configure
RUN make
RUN make install

CMD ["nsd", "-d"]
