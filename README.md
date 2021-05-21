# Container Workspace Environment for Development, Learning, and Experimentation

This [GitHub] repo and [Docker] container contain the tools I use in my
terminal-centric workspace. I use it to get a workspace quickly and to
store all my custom installation information (latest Go, borderless
TMUX, etc.)

By default, this image will interactively prompt for user creation
information the first time it is run (with defaults). This makes it
ideal for matching the exact user account I use at work and on different
projects. Sometimes I bind-mount volumes and share the host network.
Other times I use it as a sandbox disconnected from everything else.

[GitHub]: <https://github.com/rwxrob/base>
[Docker]: <https://hub.docker.com/r/rwxrob/base>

## Install and Run

To clone and work with the source code:

```
git clone --recursive git@github.com:rwxrob/workspace.git
```

To just sample run the image and remove when done (accept the defaults):

```
docker run -it --rm rwxrob/workspace
```

Note for any `docker` work you probably want to `-v
/var/run/docker.sock:/var/run/docker.sock`, which will share the docker
instance running on the host.

## Installing Outside of Workspace

Some of the scripts and content in this repo can be used to install
stuff outside of a workspace (on a host system).

To install latest Go binary (after having done `build go`):

```sh
ln -sf "$PWD/goroot" /usr/local/go
```

To add the Go utilities you might want to copy them to `/usr/local/bin`:

```sh
cp ./go/bin/* /usr/local/bin
```
