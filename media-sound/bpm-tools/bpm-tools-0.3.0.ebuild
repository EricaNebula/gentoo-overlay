# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HOMEPAGE="https://www.pogo.org.uk/~mark/bpm-tools/"
SRC_URI="https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz -> ${P}.tar.gz"
MY_PV="0.3"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

PATCHES=("${FILESDIR}/update-prefix.patch")
