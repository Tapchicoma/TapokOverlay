# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit go-module

DESCRIPTION="A rich terminal UI for GitHub that doesn't break your flow."
HOMEPAGE="https://gh-dash.dev/"
SRC_URI="https://github.com/dlvhdr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/Tapchicoma/ebuild-deps/raw/refs/heads/main/go-deps/${PN}-${PV}-deps.tar.xz"

LICENSE="GPL-3 MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

DOCS=(README.md)

src_compile() {
	go build -o release/gh-dash . || die
}

src_install() {
	dobin release/gh-dash
	einstalldocs
}

pkg_postinst() {
	elog 'Check installed documentation to how-to add this to the shell prompt'
}
