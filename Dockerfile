# Dockerfile for getting the latest version of samtools, HTSlib, and bcftools
#
# Samtools (https://www.htslib.org/) is a suite of programs for interacting with high-throughput sequencing data.
# It consists of three separate repositories:
# - Samtools: Reading/writing/editing/indexing/viewing SAM/BAM/CRAM format
# - BCFtools: Reading/writing BCF2/VCF/gVCF files and calling/filtering/summarising SNP and short indel sequence variants
# - HTSlib:   A C library for reading/writing high-throughput sequencing data
#
# to build this:
# docker build -t samtools -f Dockerfile .
#
# to run this:
# AWS_ACCESS_KEY_ID=$(aws --profile PROFILE_NAME configure get aws_access_key_id)
# AWS_SECRET_ACCESS_KEY=$(aws --profile PROFILE_NAME configure get aws_secret_access_key)
# docker run -it --rm \
#   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
#   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
#   samtools:latest
#
# now, inside the docker:
# aws s3 ls s3://BUCKET_NAME/FILE
# samtools view -H s3://BUCKET_NAME/FILE


FROM alpine:3.8

ARG samtools_version=1.9
ARG awscli_version=1.16.95

# install dependencies for htslib, bcftools, and samtools
# NOTE: py3-pip is installed because awscli is needed and currently not available in the stable release Alpine Linux
RUN apk update && \
    apk add git && \
    apk add py3-pip && \
    apk add autoconf automake make gcc musl-dev perl bash zlib-dev bzip2-dev xz-dev curl-dev libressl-dev ncurses-dev

RUN mkdir /samtools

# clone and install HTSlib
# The option `--enable-libcurl` enables s3 access support
ENV HTSLIB_VERSION $samtools_version
RUN cd /samtools && \
    git clone -b $samtools_version git://github.com/samtools/htslib.git htslib && \
    cd htslib && \
    autoheader && \
    autoconf && \
    ./configure --enable-libcurl && \
    make && \
    make install

# clone and install bcftools
ENV BCFTOOLS_VERSION $samtools_version
RUN cd /samtools && \
    git clone -b $samtools_version git://github.com/samtools/bcftools.git bcftools && \
    cd bcftools && \
    autoheader && \
    autoconf && \
    ./configure && \
    make && \
    make install

# clone and install SAMtools
ENV SAMTOOLS_VERSION $samtools_version
RUN cd /samtools && \
    git clone -b $samtools_version git://github.com/samtools/samtools.git samtools && \
    cd samtools && \
    autoheader && \
    autoconf && \
    ./configure && \
    make && \
    make install

ENV AWSCLI_VERSION $awscli_version
RUN pip3 install awscli==$awscli_version

# cleanup
RUN rm -rf /samtools && \
    apk del git autoconf automake make gcc

ENTRYPOINT ["/bin/bash"]
