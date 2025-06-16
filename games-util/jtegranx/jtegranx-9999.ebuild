# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev desktop git-r3

MY_PN="JTegraNX"
M2=${WORKDIR}/m2/cache

HOMEPAGE="https://github.com/dylwedma11748/${MY_PN}"
EGIT_REPO_URI="https://github.com/dylwedma11748/${MY_PN}.git"
EGIT_BRANCH="master"

LICENSE="GPL 2.0"
SLOT="0"
KEYWORDS=""

PATCHES=(
    # This makes the resulting jar file have a version of "9999" instead of 1.6.9-R1
    "${FILESDIR}/0003-live-version.patch"
)

BDEPEND="|| ( dev-java/maven dev-java/maven-bin )
>=virtual/jdk-1.11:*"
RDEPEND="acct-group/nintendo_switch"

src_unpack() {
    git-r3_src_unpack

    # Create a full cache of mvn deps for offline building
    mkdir -p ${M2}
    cd ${S}
    /usr/bin/mvn -Dmaven.repo.local=${M2} dependency:go-offline
}

src_compile() {
    mvn -DskipTests -Dmaven.repo.local=${M2} --offline --batch-mode clean package
}

src_install() {
    # Install udev rules
	udev_dorules ${FILESDIR}/10-nintendo-switch.rules

    # Install the jar file
	insinto /usr/share/${PN}-${SLOT}/lib
	doins target/${MY_PN}-${PV}-jar-with-dependencies.jar

    # Install the launcher
    echo '#!/bin/bash' | tee target/jtegranx
    echo "$(which java) -jar /usr/share/${PN}-${SLOT}/lib/${MY_PN}-${PV}-jar-with-dependencies.jar" | tee -a target/jtegranx
    dobin target/jtegranx

    # Install desktop file
	domenu "${FILESDIR}/jtegranx.desktop"

	# Install icon file
	doicon -s 32 "${S}/src/main/resources/images/icon.png"
}

pkg_postinst() {
    einfo ""
    einfo "You must add yourself to the 'nintendo_switch' if you do not wish to run the app as root."
    einfo "For example:"
    einfo "\t# usermod -aG nintendo_switch <username>"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}