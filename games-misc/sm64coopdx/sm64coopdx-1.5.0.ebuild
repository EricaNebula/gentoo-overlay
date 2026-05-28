# Copyright 2026 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit desktop

MY_PV="1.5"

DESCRIPTION="An online multiplayer project for the Super Mario 64 PC port"
HOMEPAGE="https://github.com/coop-deluxe/sm64coopdx"
SRC_URI="https://github.com/coop-deluxe/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz" 

LICENSE="none"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/libsdl2
	media-libs/glew
	dev-vcs/git
	net-misc/curl
	sys-libs/zlib
"

RDEPEND="${DEPEND}"

src_unpack() {
	default
	ls -l "${WORKDIR}"
	mv "${WORKDIR}/${PN}-${MY_PV}" "${WORKDIR}/${PN}-${PV}"
}

src_configure() {
	cp "${FILESDIR}/baserom.us.z64" "${S}"
}

src_compile() {
	emake
}

src_install() {
	# Install files into /opt/sm64coopdx
	insinto /opt/${PN}
	doins -r ${S}/build/us_pc/*

	# Make /opt/sm64coopdx/sm64coopdx executable
	fperms +x /opt/${PN}/sm64coopdx

	# Install the launcher stub into /usr/bin
	dobin "${FILESDIR}/sm64coopdx"

	# Install desktop file
	domenu "${FILESDIR}/sm64coopdx.desktop"

	# Install icon file
	doicon -s 128 "${FILESDIR}/sm64coopdx.png"
}
