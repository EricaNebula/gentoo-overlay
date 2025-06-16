# Copyright 2025 Erica Nebula
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev desktop

MY_PN="JTegraNX"
MY_PR="R2"
SRC_URI="https://github.com/dylwedma11748/${MY_PN}/archive/refs/tags/${PV}-${MY_PR}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}-${MY_PR}"
M2=${WORKDIR}/m2/cache

LICENSE="GPL 2.0"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
    # This was committed to master after 1.6.9 was released
    # and is necessary in order to build the project.
    "${FILESDIR}/0001-missing-dependency.patch"
    
    # pom.xml lists the version as 1.6.9-R1
    # while the tarball says 1.6.9-${MY_PR}
    # This patch makes both say 1.6.9-${MY_PR}
    "${FILESDIR}/0002-version-revision.patch"
)

BDEPEND="|| ( dev-java/maven dev-java/maven-bin )
>=virtual/jdk-1.11:*"
RDEPEND="acct-group/nintendo_switch"

# This is a huge no-no
# However, no idea how to pre-fetch the mvn deps while maintaining the tree structure.
#
# Also, this version requires a patch to be applied for a missing dep before fetching
# said deps. Which makes it hard to even do the fetching in src_unpack.
# So. Fuck it. We'll just let it be online in src_compile.
RESTRICT=network-sandbox

src_compile() {
    mkdir -p ${M2}
    mvn -DskipTests -Dmaven.repo.local=${M2} --batch-mode clean package
}

src_install() {
    # Install udev rules
	udev_dorules ${FILESDIR}/10-nintendo-switch.rules

    # Install the jar file
	insinto /usr/share/${PN}-${SLOT}/lib
	doins target/${MY_PN}-${PV}-${MY_PR}-jar-with-dependencies.jar

    # Install the launcher
    echo '#!/bin/bash' | tee target/jtegranx
    echo "$(which java) -jar /usr/share/${PN}-${SLOT}/lib/${MY_PN}-${PV}-${MY_PR}-jar-with-dependencies.jar" | tee -a target/jtegranx
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
    ewarn ""
    ewarn "This is the latest point release of this package."
    ewarn "It has bugs that this ebuild tries to patch,"
    ewarn "and as a result the ebuild ignores certain best practices."
    ewarn "Users are encouraged to use the -9999 version of this package."
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}