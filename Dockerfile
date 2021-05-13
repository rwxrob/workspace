FROM rwxrob/pandoc AS mypandoc
FROM rwxrob/hyperfine AS myhyperfine
FROM rwxrob/kubectl AS mykubectl

FROM ubuntu

LABEL MAINTAINER "Rob Muhlestein <rob@rwx.gg>"
LABEL SOURCE "https://github.com/rwxrob/dot"

COPY --from=mypandoc /usr/bin/pandoc /usr/bin
COPY --from=myhyperfine /usr/bin/hyperfine /usr/bin
COPY --from=mykubectl /usr/bin/kubectl /usr/bin

# If you are worried about RUN bloat look into docker --squash.  Joining
# everything with && is just not worth the obfuscation and loss of
# caching. In fact, using && is a docker anti-pattern unless you
# *really* need the image optimization.

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
    iputils-ping bind9-dnsutils htop libcurses-perl

RUN cpan -I Term::Animation
RUN npm install -g browser-sync


ENV GOPATH "/etc/skel/.go"
RUN go get github.com/mikefarah/yq/v4
RUN go get sigs.k8s.io/kind
RUN go get github.com/rwxrob/lolcat
RUN go get github.com/klauspost/asmfmt/cmd/asmfmt@master
RUN go get github.com/go-delve/delve/cmd/dlv@master
RUN go get github.com/kisielk/errcheck@master
RUN go get github.com/davidrjenni/reftools/cmd/fillstruct@master
RUN go get github.com/rogpeppe/godef@master
RUN go get golang.org/x/tools/cmd/goimports@master
RUN go get golang.org/x/lint/golint@master
RUN go get golang.org/x/tools/gopls@latest
RUN go get github.com/golangci/golangci-lint/cmd/golangci-lint@master
RUN go get honnef.co/go/tools/cmd/staticcheck@latest
RUN go get github.com/fatih/gomodifytags@master
RUN go get golang.org/x/tools/cmd/gorename@master
RUN go get github.com/jstemmer/gotags@master
RUN go get golang.org/x/tools/cmd/guru@master
RUN go get github.com/josharian/impl@master
RUN go get honnef.co/go/tools/cmd/keyify@master
RUN go get github.com/fatih/motion@master
RUN go get github.com/koron/iferr@master
RUN go get github.com/raviqqe/muffet
RUN go get github.com/rwxrob/cmdbox-pomo/pomo

COPY install-docker /
RUN ./install-docker

COPY install-helm /
RUN ./install-helm

COPY ./dot/scripts /etc/skel/.local/bin/scripts
COPY ./dot/bashrc /etc/skel/.bashrc
COPY ./dot/shell.d /etc/skel/.shell.d
COPY ./dot/dircolors /etc/skel/.dircolors
COPY ./dot/inputrc /etc/skel/.inputrc
COPY ./dot/profile /etc/skel/.profile
COPY ./dot/vim/vimrc /etc/skel/.vimrc
COPY ./dot/lynx /etc/skel/.config/lynx
COPY ./dot/gh /etc/skel/.config/gh
COPY ./dot/git/templates /etc/skel/.git-templates
COPY ./dot/tmux/tmux.conf /etc/skel/.tmux.conf
COPY ./dot/tmux/tmux-live.conf /etc/skel/.tmux-live.conf
COPY ./fonts/figlet/* /usr/share/figlet/

RUN curl -fLo /etc/skel/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

WORKDIR /etc/skel/.vimplugins
RUN git clone http://github.com/z0mbix/vim-shfmt.git
RUN git clone http://github.com/sheerun/vim-polyglot.git
RUN git clone http://github.com/vim-pandoc/vim-pandoc.git
RUN git clone http://github.com/rwxrob/vim-pandoc-syntax-simple.git
RUN git clone http://github.com/cespare/vim-toml.git
RUN git clone http://github.com/pangloss/vim-javascript.git
RUN git clone http://github.com/fatih/vim-go.git
RUN git clone http://github.com/PProvost/vim-ps1.git
RUN git clone http://github.com/tpope/vim-fugitive.git
RUN git clone http://github.com/morhetz/gruvbox.git
RUN git clone http://github.com/roxma/vim-tmux-clipboard.git

COPY entrypoint /
ENTRYPOINT ["sh","/entrypoint"]
