FROM quay.io/fedora/fedora-bootc:43

RUN systemctl disable bootloader-update.service && systemctl mask bootloader-update.service

#RUN echo 'kargs = ["console=tty0", "cpufreq.default_governor=performance"]' >> /usr/lib/bootc/kargs.d/00-console.toml
RUN echo 'kargs = ["console=ttyS0,9600", "cpufreq.default_governor=performance"]' >> /usr/lib/bootc/kargs.d/00-console.toml

RUN <<EOF
echo -e '[etc]\ntransient = true' > /usr/lib/ostree/prepare-root.conf
set -x; kver=$(cd /usr/lib/modules && echo *); dracut -vf /usr/lib/modules/$kver/initramfs.img $kver
EOF

RUN <<EOF
echo "root:toor" | chpasswd
sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
EOF
