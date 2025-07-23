# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

HOMEPAGE="https://www.pogo.org.uk/~mark/bpm-tools/"
EGIT_REPO_URI="https://www.pogo.org.uk/~mark/${PN}.git"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS=""

PATCHES=("${FILESDIR}/update-prefix.patch")
