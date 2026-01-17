# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT_HASH="e60fe3d99b545d7e42ff2f5278efa5822668a57c"

DESCRIPTION="The Klipper firmware sources to control 3d-Printers."
HOMEPAGE="https://www.klipper3d.org/"
SRC_URI="https://github.com/Klipper3d/klipper/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=" ~amd64 arm ~arm64"
IUSE="doc"
RESTRICT="test strip"

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/klipper-${COMMIT_HASH}/* "${S}"/ || die
	rm -r "${WORKDIR}"/klipper-${COMMIT_HASH} || die
}

src_prepare() {
	default

	if ! use doc; then
		rm -r "${S}"/config
		rm -r "${S}"/docs
	fi
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
	fperms 0755 usr/src/klipper-sources/scripts/check-gcc.sh
}

pkg_postinst() {
	elog "To compile firmware install ARM toolchain: 'crossdev -S --target arm-none-eabi'"
	elog "You may also need to recompile 'newlib' with 'nano' flag afterwards"
}
