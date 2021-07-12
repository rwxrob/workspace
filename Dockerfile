FROM ubuntu

LABEL MAINTAINER "Rob Muhlestein <rob@rwx.gg>"
LABEL SOURCE "https://github.com/rwxrob/workspace"

ENV DEBIAN_FRONTEND=noninteractive

RUN yes | unminimize && \
    apt-get -y --no-install-recommends upgrade && \
    apt-get install -y \
        apt-utils \
        build-essential \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        man-db \
        curl \
        && \
    apt-key adv \
        --keyserver keyserver.ubuntu.com \
        --recv-key C99B11DEB97541F0 \
        && \
    apt-add-repository https://cli.github.com/packages && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        vim tmux dialog perl python git gh jq sudo lynx shellcheck \
        figlet sl tree nmap ed bc iputils-ping bind9-dnsutils htop \
        libncurses5 libcurses-perl net-tools ssh sshpass sshfs rsync \
        cifs-utils smbclient bash-completion make wget less lolcat\
        && \
    cpan -I Term::Animation && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/dmesg.* && \
    cat /dev/null > /var/log/dmesg

COPY ./files/. ./Dockerfile /

WORKDIR /usr/share/rwxrob/workspace 

RUN /usr/share/workspace/.local/bin/install-docker && \
    /usr/share/workspace/.local/bin/install-helm && \
    /usr/share/workspace/.local/bin/install-kubectl && \
    /usr/share/workspace/.local/bin/install-pandoc && \
    /usr/share/workspace/.local/bin/install-hyperfine

ENTRYPOINT ["sh","/entry"]
