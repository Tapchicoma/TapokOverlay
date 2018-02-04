# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The kotlin programming language compiler"
HOMEPAGE="https://kotlinlang.org"
SRC_URI="https://github.com/JetBrains/kotlin/releases/download/v${PV}/kotlin-compiler-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
		>=virtual/jdk-1.8
"

S="${WORKDIR}/kotlinc"

src_prepare() {
	# Remove Windows runnables
	cd "${S}/bin"
	rm *.bat

	default
}

src_install() {
	local dest="/opt/${P}"

	dodir "$dest"

	dodir "$dest/bin"
	cp -pPR "${S}/bin" "${D}/${dest}" || die "Install failed"

	dodir "$dest/lib"
	cp -pPR "${S}/lib" "${D}/${dest}" || die "Install failed"

	dodoc "${S}/build.txt"
	dodoc -r "${S}/license"

	dodir "/opt/bin"
	dosym "${dest}/bin/kotlinc" "/opt/bin/kotlinc"
}
