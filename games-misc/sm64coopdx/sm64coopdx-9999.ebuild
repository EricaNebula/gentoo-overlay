# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit git-r3

DESCRIPTION="An online multiplayer project for the Super Mario 64 PC port"
HOMEPAGE="https://github.com/coop-deluxe/sm64coopdx"
EGIT_REPO_URI="https://github.com/coop-deluxe/sm64coopdx.git"
EGIT_BRANCH="dev"

LICENSE="none"
SLOT="0"
KEYWORDS=""

DEPEND="media-libs/libsdl2
media-libs/glew
dev-vcs/git
net-misc/curl
sys-libs/zlib"

RDEPEND="${DEPEND}"

src_configure() {
	cp "${FILESDIR}/baserom.us.z64" "$S"
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR=${D} install
}

