# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="https://zealdocs.org/"
SRC_URI="https://github.com/zealdocs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-arch/libarchive
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=x11-libs/xcb-util-keysyms-0.3.9
"

RDEPEND="
	${DEPEND}
	x11-themes/hicolor-icon-theme
"

src_configure() {
        cmake-utils_src_configure PREFIX="${EPREFIX}/usr"
}

src_install() {
	cmake-utils_src_install INSTALL_ROOT="${D}" PREFIX="${EPREFIX}/usr" install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
        xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
        xdg_desktop_database_update
}
