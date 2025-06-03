# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Extension to the VLC player which allows you to easily generate GIFs from watched content"
HOMEPAGE="https://github.com/Dante383/VLC-GIF-Maker"
MY_PN="VLC-GIF-Maker"
SRC_URI="https://github.com/Dante383/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
    "${FILESDIR}/0001-20fps.patch"
	"${FILESDIR}/0002-fix-spaces.patch"
)

RDEPEND="media-video/vlc"

src_install() {
	insinto /usr/lib64/vlc/lua/extensions
	doins vlc_gif_maker.lua
}

