SSH_PUBLIC_RSA_KEY=AAAAB3NzaC1yc2EAAAADAQABAAABAQDbbBHjqy6NB4O6K7guEzFUeGZtZqoFu5I+gZhZ2nB8c+AeWaQguvh8PuaZS+c21MxY49TmiTH4Xl0Tt6BrEDswkD3YS5zuALsn7TGOwFexsdK0s+48+ysxtLnL+xT4u0eR1yeb1aGWccja2OzObOtCIqoMK4gzrLu0MujfHiZBKoMKUNEGnRBKubqI7D1NSF2FgHo0i5g4d7+WehI+LEq6/Iv1O9dXWmXmbSiDyP4r2QZGvZkQlPpM0LRzROT24EDT5/AknHo9czIkM72nTnxhhItYFVx+edBDxVYHn0Cy6i1tolw4g6Kz40WElT417gI16Jnqo+kprw/1u6Gv1uJt
SSH_PUBLIC_RSA_KEY1=AAAAB3NzaC1yc2EAAAADAQABAAABAQCoagmg5NalA6vgZi/XMGVaYJlsKQoHp6BCMRLMpbyXTx1Ms1CDCJDFBvSDF75H+/vHQkgYMcMCJHLJkXC2pxeJFcr27UXsAF/bTV3n4ZkHFL1AINMCL112R4kXlZUaTvDZyhMgfbjRoOKawh8UQWCR5e2ZfgWT2gs2tflHlUkfkApGkyhpNex/F5HcYUs5DzxrdQstlQ1yRjE1tknEsM6O1r7vg6nn5wivj3e8lFDyV8ay84Is+o4u3yxVzrZUkeYK4JA3GW0S0RRROoiVcTzIfpoxRa9E9fRdXMVP2zGgUghw6ySBCVXMzp+x3rfdswFA+62txorNv9PawyCqZ88l
MB=4096
MB=2048
DOC_PKGS="bubblewrap-doc"
#BASE_PKGS="virtualbox-guest-additions zsh git sudo curl libuser shadow vim ripgrep wireguard-tools wget wireguard-tools ripgrep socat rsync ifupdown-ng-wireguard wireguard-tools wireguard-tools-bash-completion wireguard-tools-doc wireguard-tools-wg-quick"
#virtualbox-guest-additions zsh git sudo curl libuser shadow vim ripgrep wireguard-tools wget wireguard-tools ripgrep socat rsync ifupdown-ng-wireguard wireguard-tools wireguard-tools-bash-completion wireguard-tools-doc wireguard-tools-wg-quick"
DEVEL_PKGS="cmake make gcc musl-dev libc-dev coreutils bat autoconf automake libseccomp-static libseccomp jsonrpc-glib-dev cjson-dev json-c-dev jsonnet-dev libseccomp libseccomp-dev libseccomp-static"
ALL_PKGS=
#"$DEVEL_PKGS $DOC_PKGS abduco ansible autoconf automake bat bubblewrap cargo coreutils curl direnv docker-cli docker-cli-buildx docker-compose docker-registry dvtm e2tools elogind execline execline-dev file fish gcc git go gocryptfs htop ifupdown-ng-wireguard img jansson jansson-dev jq libuser libvirt-daemon linux-headers lxc make man-db-doc mandoc mariadb musl-dev ngrep nload nodejs npm openssh-client openssh-server openssl pango pkgconfig psmisc py3-dockerpty py3-pip restic ripgrep rsync runc-doc rust s6 s6-dns s6-ipcserver s6-linux-init s6-linux-init-dev s6-linux-utils s6-networking s6-networking-dev s6-networking-static s6-openrc s6-portable-utils s6-rc s6-rc-dev s6-rc-static setpriv shadow skalibs skalibs-dev socat strace sudo sysstat tcpdump termrec tmux ttyd util-linux vim virt-install vnstat wireguard-tools wireguard-tools-bash-completion wireguard-tools-doc wireguard-tools-wg-quick zsh g++ libc-dev build-base mpc1-dev make build-base skopeo bubblewrap-bash-completion yajl yajl-tools yajl-dev dconf-dev dconf nodejs npm py3-pip docker gettext-static gettext-dev gettext $DOC_PKGS"
BASE_PKGS="$ALL_PKGS"

#ZSH_THEME=agnoster
ZSH_THEME=alpine

CPUS=4
DISK_MB=10000

SSH_CONFIG_INCLUDE_DIR=~/.ssh/config.d/packer

APK_PROXY_PORT=29332
APK_PROXY_HOST=192.168.1.11
