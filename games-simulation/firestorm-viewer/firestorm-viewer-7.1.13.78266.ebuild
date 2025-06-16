# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 desktop

DESCRIPTION="Firestorm is a third party viewer derived from the official Second Life client."
HOMEPAGE="https://www.firestormviewer.org/"

if [[ ${PV} == "9999" ]]; then
    EGIT_REPO_URI="https://github.com/FirestormViewer/phoenix-firestorm.git"
    EGIT_BRANCH="master"
    inherit git-r3
else
    SRC_URI="https://github.com/FirestormViewer/phoenix-firestorm/archive/refs/tags/Firestorm_Release_${PV}.tar.gz -> ${P}.tar.gz"
    S="${WORKDIR}/phoenix-firestorm-Firestorm_Release_${PV}"
    KEYWORDS="~amd64"
fi

LICENSE=""
SLOT="0"
IUSE="+fmodstudio cpu_flags_x86_avx2 opensim"

PATCHES=(
    "${FILESDIR}/append-unofficial.patch"
    "${FILESDIR}/point-release-revision.patch"
)

BDEPEND="
dev-vcs/mercurial
fmodstudio? ( net-misc/3p-fmodstudio )
media-libs/mesa
net-libs/libssh
media-libs/libpulse
x11-libs/libXrandr
x11-libs/libXinerama
media-libs/freetype
media-libs/fontconfig
dev-build/cmake
dev-libs/glib
sys-libs/glibc
sys-devel/gcc:11
net-misc/fs-build-variables
$(python_gen_cond_dep '
    dev-python/autobuild[${PYTHON_USEDEP}]
    dev-python/llbase[${PYTHON_USEDEP}]
    dev-python/llsd[${PYTHON_USEDEP}]
    dev-python/pyzstd[${PYTHON_USEDEP}]
')"

RDEPEND="${BDEPEND}"

# This is a huge no-no
# However, the alternative is to figure out what autobuild is going to fetch
# and then find a way to pre-fetch all of it in a way that can be used for offline building.
# Autobuild doesn't have a way to do that, so one would have to be created from scratch.
# That's definitely out of scope for this so long as it lives outside of GURU.
RESTRICT=network-sandbox

src_compile() {
    export AUTOBUILD_VARIABLES_FILE=/usr/share/firestorm-viewer/fs-build-variables/variables
    export CC=/usr/x86_64-pc-linux-gnu/gcc-bin/11/gcc
    export CXX=/usr/x86_64-pc-linux-gnu/gcc-bin/11/g++
    export CXXFLAGS="${CXXFLAGS} -std=gnu++20"

    # fmodstudio is optional but highly recommended.
    if use fmodstudio; then
        RESULT_FILE="/usr/share/firestorm-viewer/3p-fmodstudio/result.txt"
        if [ -f $RESULT_FILE ]; then
            FMOD_MD5=$(grep autobuild_package_md5 ${RESULT_FILE} | cut -d'=' -f2 | sed 's/"//g')
            echo FMOD MD5: ${FMOD_MD5}
        else
            die "Unable to find $RESULT_FILE. Please reinstall net-misc/3p-fmodstudio."
        fi

        FMOD_FILE=$(ls -1 /usr/share/firestorm-viewer/3p-fmodstudio/fmodstudio-*linux64-*.tar.bz2)
        if [ -f ${FMOD_FILE} ]; then
            echo autobuild installables edit fmodstudio platform=linux64 hash=${FMOD_MD5} url=file:///${FMOD_FILE}
            autobuild installables edit fmodstudio platform=linux64 hash=${FMOD_MD5} url=file:///${FMOD_FILE}    
        else
            die "Could not find fmod studio api file. Please reinstall net-misc/3p-fmodstudio."
        fi
    fi

    # We are managing our own installation
    AUTOBUILD_FLAGS="--no-package"

    # Just affects the titlebar of the app, really
    if [[ ${PV} == "9999" ]]; then
        AUTOBUILD_FLAGS="${AUTOBUILD_FLAGS} --chan=Nebula-Live"
    else
        AUTOBUILD_FLAGS="${AUTOBUILD_FLAGS} --chan=Nebula-Release"
    fi

    # Build Firestorm with different autobuild flags depending on USE flag values.
    if use cpu_flags_x86_avx2; then AUTOBUILD_FLAGS="${AUTOBUILD_FLAGS} --avx2"; fi
    if ! use opensim; then AUTOBUILD_FLAGS="${AUTOBUILD_FLAGS} --no-opensim"; fi
    if use fmodstudio; then AUTOBUILD_FLAGS="${AUTOBUILD_FLAGS} --fmodstudio"; fi

    # The configure command pulls in all of the deps
    # I could run this in src_unpack but that would still be the wrong place for it.
    echo autobuild configure -A 64 -c ReleaseFS_open -- --clean $AUTOBUILD_FLAGS
    autobuild configure -A 64 -c ReleaseFS_open -- --clean $AUTOBUILD_FLAGS

    # Build can then be fully offline
    echo autobuild build -A 64 -c ReleaseFS_open -- $AUTOBUILD_FLAGS
    autobuild build -A 64 -c ReleaseFS_open -- $AUTOBUILD_FLAGS
}

src_install() {

    # Remove unnecessary Windows DLLs
    rm -r build-linux-x86_64/newview/packaged/bin/win32
    rm -r build-linux-x86_64/newview/packaged/bin/win64

    # Install viewer files
    insinto /opt/firestorm-viewer
    doins -r build-linux-x86_64/newview/packaged/*

    # Set executable permissions where needed
    fperms +x /opt/firestorm-viewer/firestorm
    fperms +x /opt/firestorm-viewer/install.sh
    fperms +x /opt/firestorm-viewer/secondlife-i686.supp
    fperms +x /opt/firestorm-viewer/bin/SLPlugin
    fperms +x /opt/firestorm-viewer/bin/SLVoice
    fperms +x /opt/firestorm-viewer/bin/chrome-sandbox
    fperms +x /opt/firestorm-viewer/bin/do-not-directly-run-firestorm-bin
    fperms +x /opt/firestorm-viewer/bin/dullahan_host
    fperms +x /opt/firestorm-viewer/bin/linux-crash-logger.bin
    fperms +x /opt/firestorm-viewer/bin/snapshot_blob.bin
    fperms +x /opt/firestorm-viewer/bin/v8_context_snapshot.bin
    fperms +x /opt/firestorm-viewer/bin/llplugin/libmedia_plugin_cef.so
    fperms +x /opt/firestorm-viewer/bin/llplugin/libmedia_plugin_gstreamer.so

    # Symlink the main executable
    dosym /opt/firestorm-viewer/firestorm /usr/bin/firestorm

	# Install desktop file
	domenu "${FILESDIR}/firestorm-viewer.desktop"

	# Install icon file
	doicon -s 48 "/opt/firestorm-viewer/firestorm_48.png"
}
