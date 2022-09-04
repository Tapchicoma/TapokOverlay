# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"

inherit xdg cmake desktop wxwidgets

MY_PN="SuperSlicer"
DESCRIPTION="A mesh slicer to generated G-Code for fused-filament fabrication"
HOMEPAGE="https://github.com/supermerill/SuperSlicer"
SRC_URI="https://github.com/supermerill/SuperSlicer/archive/${PV}.tar.gz -> ${P}.tar.gz
	profiles? ( https://github.com/slic3r/slic3r-profiles/archive/5559a75b7acb14ae0c8c222b3a9c1fa7239a317e.zip -> ${P}-profiles.zip )"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="AGPL-3"
SLOT="24"
KEYWORDS="~amd64"
IUSE="gui test profiles"

RDEPEND="test? ( gui )"
RESTRICT="!test? ( test )"

BDEPEND="profiles? ( app-arch/unzip )"
RDEPEND="
		dev-cpp/eigen:3
		>=dev-cpp/tbb-2021.4.0:=
		>=dev-libs/boost-1.73.0:=[nls,threads(+)]
		dev-libs/cereal
		dev-libs/expat
		dev-libs/c-blosc
		dev-libs/gmp:=
		>=dev-libs/miniz-2.2.0-r1
		dev-libs/mpfr:=
		>=media-gfx/openvdb-8.2:=
		media-libs/libpng:0=
		media-libs/qhull:=
		sci-libs/libigl
		sci-libs/nlopt
		>=sci-mathematics/cgal-5.0:=
		sys-apps/dbus
		sys-libs/zlib:=
		gui? (
				dev-libs/glib:2
				media-libs/glew:0=
				net-misc/curl
				virtual/glu
				virtual/opengl
				x11-libs/gtk+:3
				>=x11-libs/wxGTK-3.0.5.1:=[X,opengl]
		)
"
DEPEND="${RDEPEND}
		media-libs/qhull[static-libs]
		test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/missing-imports-${PV}.patch"
	"${FILESDIR}/version-suffix-${PV}.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
	for file in ${S}/resources/icons/SuperSlicer*; do
		prefix=${file%"SuperSlicer"*}
		suffix=${file#"${prefix}SuperSlicer"}
		mv "$file" "${prefix}SuperSlicer2.4${suffix}"
	done

	use profiles && unpack ${P}-profiles.zip
	if use profiles ; then
		cp -r "${WORKDIR}/slic3r-profiles-5559a75b7acb14ae0c8c222b3a9c1fa7239a317e/"* "${S}/resources/profiles" || die "Failed to copy profiles"
	fi
}

src_configure() {
	use gui && setup-wxwidgets

	CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DOPENVDB_FIND_MODULE_PATH="/usr/$(get_libdir)/cmake/OpenVDB"

		-DSLIC3R_BUILD_TESTS=$(usex test)
		-DSLIC3R_FHS=ON
		-DSLIC3R_GUI=$(usex gui)
		-DSLIC3R_PCH=OFF
		-DSLIC3R_WX_STABLE=ON
		-DSLIC3R_STATIC=OFF
		-Wno-dev
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use gui; then
		newicon -s 128 resources/icons/SuperSlicer2.4_128px.png SuperSlicer2.4.png
	fi
}
