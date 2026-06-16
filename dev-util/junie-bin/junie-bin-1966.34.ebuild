# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An AI coding agent by JetBrains"
HOMEPAGE="https://junie.jetbrains.com/"

SRC_URI="https://github.com/JetBrains/junie/releases/download/${PV}/junie-release-${PV}-linux-amd64.zip -> ${P}-amd64.zip"

S="${WORKDIR}"
LICENSE="JETBRAINS-SRO"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/junie"

src_install() {
	insinto /usr/share/junie
	doins -r junie-app/lib
	doins -r junie-app/bin
	doexe /usr/share/junie/bin/junie

	dobin "${FILESDIR}"/junie
}
