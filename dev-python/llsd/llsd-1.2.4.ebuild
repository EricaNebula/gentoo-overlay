# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Official python serialization library for Linden Lab Structured Data (LLSD)."
HOMEPAGE="https://github.com/secondlife/python-llsd"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="                                                                                                                                 
    dev-python/setuptools[${PYTHON_USEDEP}]                                                                                               
"

distutils_enable_tests pytest