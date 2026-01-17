# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="b0bf421069e2aab810db43d6e15f38817d981451"

DESCRIPTION=" Configurable bootloader for Klipper"
HOMEPAGE="https://github.com/Arksine/Katapult"
SRC_URI="https://github.com/Arksine/Katapult/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm arm64"
RESTRICT="test strip"

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/katapult-${COMMIT}/* "${S}"/ || die
	rm -r "${WORKDIR}"/katapult-${COMMIT} || die
}

src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	insinto /usr/src/
	doins -r "${S}"
	fperms 0755 usr/src/katapult-sources/scripts/check-gcc.sh
}

pkg_postinst() {
	elog "To compile firmware install ARM toolchain: 'crossdev -S --target arm-none-eabi'"
	elog "You may also need to recompile 'newlib' with 'nano' flag afterwards"
}
