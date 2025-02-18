# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Klipper firmware sources to control 3d-Printers."
HOMEPAGE="https://www.klipper3d.org/"
SRC_URI="https://github.com/Klipper3d/klipper/archive/fec3e685c92ef263a829a73510c74245d7772c03.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=" ~amd64 arm ~arm64"
RESTRICT="test strip"

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/klipper-fec3e685c92ef263a829a73510c74245d7772c03/* "${S}"/ || die
	rm -r "${WORKDIR}"/klipper-fec3e685c92ef263a829a73510c74245d7772c03 || die
}

src_prepare() {
	default

	rm -r "${S}"/config
	rm -r "${S}"/klippy
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
}
