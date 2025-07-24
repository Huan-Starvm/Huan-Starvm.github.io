#/bin/bash
apt install apt-transport-https ca-certificates -y

cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware

deb https://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
EOF

apt update && apt full-upgrade -y

cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ trixie-backports main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ trixie-backports main contrib non-free non-free-firmware

deb https://deb.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware
EOF

apt update && apt full-upgrade -y