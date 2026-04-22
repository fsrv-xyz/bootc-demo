FROM quay.io/fedora/fedora-bootc:44

RUN echo 'kargs = ["console=tty0", "cpufreq.default_governor=performance", "systemd.gpt_auto=no"]' >> /usr/lib/bootc/kargs.d/00-console.toml
#RUN echo 'kargs = ["console=ttyS0,9600", "cpufreq.default_governor=performance", "systemd.gpt_auto=no"]' >> /usr/lib/bootc/kargs.d/00-console.toml

RUN <<EOF
echo -e '[etc]\ntransient = true' > /usr/lib/ostree/prepare-root.conf
set -x; kver=$(cd /usr/lib/modules && echo *); dracut -vf /usr/lib/modules/$kver/initramfs.img $kver
EOF

RUN <<EOF
dnf install -y qemu-guest-agent
dnf clean all
systemctl enable qemu-guest-agent
EOF

RUN <<EOF
echo "root:toor" | chpasswd
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
EOF
