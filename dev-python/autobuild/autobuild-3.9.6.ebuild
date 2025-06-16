# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Linden Lab Automated Package Management and Build System. Autobuild is a framework for building packages and for managing the dependencies of a package on other packages."
HOMEPAGE="https://wiki.secondlife.com/wiki/Autobuild"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/0001-exclude-more-tests.patch"
)

RDEPEND="                                                                                                                                 
    dev-python/setuptools[${PYTHON_USEDEP}]                                                                                               
"

distutils_enable_tests pytest