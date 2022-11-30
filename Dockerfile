FROM golang:1.13 AS builder

RUN apt-get -y update && \
    apt-get -y install \
                    libclang1-11 \
                    openjdk-11-jre \
                    protobuf-compiler 

RUN git clone https://github.com/GoogleCloudPlatform/healthcare-data-harmonization

WORKDIR /go/healthcare-data-harmonization

# The target will be linked to /go/bin/whistle which is what we'll recommend
# users to call when running whistle from this container
RUN mkdir -p /dist && \
    sh build_all.sh && \
    cp /go/healthcare-data-harmonization/mapping_engine/main/main /dist/whistle && \
    mkdir -p /work

WORKDIR /dist

# Copy the libraries needed to make whistle run
RUN ldd /dist/whistle | tr -s '[:blank:]' '\n' | grep '^/' | \
    xargs -I % sh -c 'mkdir -p $(dirname ./%); cp % ./%;' && \
    mkdir -p lib64 && cp /lib64/ld-linux-x86-64.so.2 lib64/ 

FROM python:3.7-alpine
RUN mkdir -p /lib64 /lib
COPY --from=builder /lib64 /lib64
COPY --from=builder /lib /lib
COPY --from=builder /dist /usr/local/bin
COPY --from=builder /work /work

RUN apk update && apk add git libffi-dev
RUN apk add build-base
#RUN apk add --no-cache bash
RUN which gcc

RUN pip3 install --upgrade pip
RUN pip3 install PyYAML \
        importlib_resources \
        git+https://git@github.com/ncpi-fhir/ncpi-fhir-utility.git \
        git+https://github.com/ncpi-fhir/ncpi-fhir-client
RUN pip3 install git+https://github.com/NIH-NCPI/ncpi-whistler

# /work is the working directory. Users should map the root directory of 
# their project to this mount point and references to the initial whistle file
# should be relative to that directory (as should any of the other arguments
# passed to whistle). Do keep in mind that the docker image only knows about 
# data that is mounted. So, if you need to point to directories outside this
# particular mount point, you will need to add them via the docker command in 
# addition to the map to /work 
WORKDIR /work
