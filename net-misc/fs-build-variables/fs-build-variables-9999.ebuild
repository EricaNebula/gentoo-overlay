# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Centralize string data common to many builds for Firestorm Viewer"
HOMEPAGE="https://github.com/FirestormViewer/fs-build-variables"
EGIT_REPO_URI="https://github.com/FirestormViewer/fs-build-variables.git"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS=""

src_install() {
	insinto /usr/share/firestorm-viewer/fs-build-variables
	doins "${S}/convenience"
    doins "${S}/functions"
    doins "${S}/variables"
}