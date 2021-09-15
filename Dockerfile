FROM ubuntu:14.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN echo "- update image -" && \
    apt-get update && \
    apt-get upgrade -y

RUN echo '- install needed packages -' && \
    apt-get install -y \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    python \
    python-dev \
    python-pip \
    wget

WORKDIR /app
COPY test-app/requirements.txt .

RUN echo "- install requirements -" && \
    wget -O /tmp/distribute.tar.gz https://pypi.python.org/packages/source/d/distribute/distribute-0.6.10.tar.gz && \
    tar -xvf /tmp/distribute.tar.gz -C /tmp/ && \
    sed -i 's/http/https/g' /tmp/distribute-0.6.10/distribute_setup.py && \
    python /tmp/distribute-0.6.10/distribute_setup.py && \
    wget -O /tmp/get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python /tmp/get-pip.py && \
    pip2 install -r requirements.txt --ignore-installed && \
    rm requirements.txt

RUN echo "- cleanup -" && \
    apt-get remove -y wget && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf \
        /app/distribute-0.6.10.tar.gz \
        /root/.cache \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

CMD ["python", "start.py"]