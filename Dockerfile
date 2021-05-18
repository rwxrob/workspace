FROM rwxrob/pandoc AS mypandoc
FROM rwxrob/hyperfine AS myhyperfine
FROM rwxrob/kubectl AS mykubectl

FROM ubuntu

LABEL MAINTAINER "Rob Muhlestein <rob@rwx.gg>"
LABEL SOURCE "https://github.com/rwxrob/dot"

COPY --from=mypandoc /usr/bin/pandoc /usr/bin
COPY --from=myhyperfine /usr/bin/hyperfine /usr/bin
COPY --from=mykubectl /usr/bin/kubectl /usr/bin

# If you are worried about RUN bloat just remember that joining
# everything with && is often docker anti-pattern that defeats local and
# remote caching optimizations.

RUN apt update -y
RUN yes | unminimize
RUN apt install -y  apt-utils software-properties-common \
    apt-transport-https ca-certificates man-db curl
RUN apt-key adv --keyserver keyserver.ubuntu.com  \
    --recv-key C99B11DEB97541F0
RUN apt-add-repository https://cli.github.com/packages
RUN add-apt-repository ppa:git-core/ppa
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt update -y

RUN apt install -y vim tmux dialog perl python git gh jq sudo lynx \
    golang-go shellcheck nodejs npm figlet sl tree nmap \
    iputils-ping bind9-dnsutils htop libcurses-perl ssh rsync

RUN cpan -I Term::Animation

WORKDIR /usr/share/rwxrob/workspace

COPY ./install-helm ./.local/bin/
RUN .local/bin/install-helm 

COPY ./install-docker ./.local/bin/
RUN .local/bin/install-docker

RUN npm install -g browser-sync

COPY ./fonts/figlet/* /usr/share/figlet/

WORKDIR /usr/share/rwxrob/workspace/.vimplugins
RUN curl -fLo ./.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY clone-vim-plugins .
RUN ./clone-vim-plugins

WORKDIR /usr/share/rwxrob/workspace/.config
COPY ./dot/lynx/ ./dot/gh/ ./

WORKDIR /usr/share/rwxrob/workspace
COPY \
    ./dot/.bashrc \
    ./dot/.dircolors \
    ./dot/.inputrc \
    ./dot/.profile \
    ./dot/vim/.vimrc \
    ./dot/tmux/.tmux.conf \
    ./dot/tmux/.tmux-live.conf \
./

COPY ./dot/git/.git-templates ./.git-templates/
COPY ./dot/.shell.d ./.shell.d/
COPY ./dot/scripts ./.local/bin/scripts/
COPY ./go/bin /usr/local/bin/

WORKDIR /
COPY ./entrypoint ./Dockerfile ./
ENTRYPOINT ["sh","/entrypoint"]
