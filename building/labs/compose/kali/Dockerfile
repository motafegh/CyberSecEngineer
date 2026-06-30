FROM kalilinux/kali-rolling

RUN apt update && apt install -y \
    nmap \
    netcat-openbsd \
    nikto \
    gobuster \
    dirb \
    ffuf \
    sqlmap \
    hydra \
    john \
    sudo \
    curl \
    wget \
    tcpdump \
    python3 \
    python3-pip \
    git \
    jq \
    ncat \
    socat \
    iproute2 \
    dnsutils \
    iputils-ping \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:analyst" | chpasswd && \
    usermod -aG sudo analyst

USER analyst
WORKDIR /home/analyst

RUN mkdir -p reports evidence tools

CMD ["/bin/bash"]
