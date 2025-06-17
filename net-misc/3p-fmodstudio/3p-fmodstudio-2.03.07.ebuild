# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="fmodstudio build scripts and autobuild frameworking for Firestorm Viewer"
HOMEPAGE="https://github.com/FirestormViewer/3p-fmodstudio"
COMMIT="f739ae6a0a635bf8a897ff3fc3d7719e417b43c9"
SRC_URI="https://github.com/FirestormViewer/3p-fmodstudio/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${COMMIT}

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="net-misc/fs-build-variables
$(python_gen_cond_dep 'dev-python/autobuild[${PYTHON_USEDEP}]')"

src_configure() {
    FMOD_FILEVER=$(echo ${PV} | sed 's/\.//g')
    FMOD_FILE="fmodstudioapi${FMOD_FILEVER}linux.tar.gz"

    if [ -e "${FILESDIR}/${FMOD_FILE}" ]; then
	    cp "${FILESDIR}/${FMOD_FILE}" "$S"
    else
        die "You must download FMOD Studio API ${PV} from https://www.fmod.com/download#fmodengine. Download requires login. Place ${FMOD_FILE} file into /var/db/repos/nebula/net-misc/3p-fmodstudio/files and retry."
    fi
}

src_compile() {
    export AUTOBUILD_VARIABLES_FILE=/usr/share/firestorm-viewer/fs-build-variables/variables
    autobuild build -A 64 --all
    autobuild package -A 64 --results-file result.txt
}

src_install() {
    OUTFILE=$(ls -1 ${S}/fmodstudio-${PV}-linux64-*.tar.bz2 | tr '\n' '\0' | xargs -0 -n 1 basename)

    # Install the output file and the results.txt file
	insinto /usr/share/firestorm-viewer/3p-fmodstudio
	doins "${S}/${OUTFILE}"
    doins "${S}/result.txt"
}