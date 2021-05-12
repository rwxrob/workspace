# Base Workspace Docker Container Image

![WIP](https://img.shields.io/badge/status-wip-red)

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

To just sample run it and remove when done (accept the defaults):

```
docker run -it --rm rwxrob/base
```

Note for any `docker` work you probably want to `-v
/var/run/docker.sock:/var/run/docker.sock`, which will share the docker
instance running on the host.

