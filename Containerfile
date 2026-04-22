FROM quay.io/fedora/fedora-bootc:44

# System Configuration
RUN echo 'kargs = ["console=tty0", "cpufreq.default_governor=performance", "systemd.gpt_auto=no"]' >> /usr/lib/bootc/kargs.d/00-console.toml

RUN <<EOF
echo -e '[etc]\ntransient = true' > /usr/lib/ostree/prepare-root.conf
set -x; kver=$(cd /usr/lib/modules && echo *); dracut -vf /usr/lib/modules/$kver/initramfs.img $kver
EOF

RUN <<EOF
dnf install -y qemu-guest-agent
dnf clean all
systemctl enable qemu-guest-agent
EOF

# Workload
RUN mkdir -p /etc/newsfeed/
COPY workload/newsfeed.config.json /etc/newsfeed/config.json
COPY workload/newsfeed.container   /usr/share/containers/systemd
RUN ln -s /usr/share/containers/systemd/newsfeed.container /usr/lib/bootc/bound-images.d/newsfeed.container

# Auth
RUN <<EOF
echo "root:toor" | chpasswd
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
EOF
