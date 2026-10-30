# Copyright 2025-2026 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..15} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Linden Lab Automated Package Management and Build System. Autobuild is a framework for building packages and for managing the dependencies of a package on other packages."
HOMEPAGE="https://wiki.secondlife.com/wiki/Autobuild"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}/0001-exclude-more-tests.patch"
)

src_configure() {
    export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
    default
}

distutils_enable_tests pytest