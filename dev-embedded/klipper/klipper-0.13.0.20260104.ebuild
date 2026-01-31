# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit python-r1

COMMIT_HASH="e60fe3d99b545d7e42ff2f5278efa5822668a57c"
EDDY_NG_COMMIT_HASH="c7ca62edb2f479a1533e2790863a6667d1fd4a48"

DESCRIPTION="The Klipper service to control 3d-Printers."
HOMEPAGE="https://www.klipper3d.org/"
SRC_URI="https://github.com/Klipper3d/klipper/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz
	eddy-ng? ( https://github.com/vvuk/eddy-ng/archive/${EDDY_NG_COMMIT_HASH}.tar.gz -> eddy-ng.tar.gz )"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 arm arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="can doc eddy-ng inputshaper source"
RESTRICT="test strip"

RDEPEND="${PYTHON_DEPS}
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	acct-group/klipper
	acct-user/klipper
	!!dev-embedded/klipper-sources
	inputshaper? ( dev-python/numpy[${PYTHON_USEDEP}] )
	inputshaper? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	can? ( dev-python/python-can[${PYTHON_USEDEP}] )
	eddy-ng? ( dev-python/scipy[${PYTHON_USEDEP}] )
	eddy-ng? ( dev-python/plotly[${PYTHON_USEDEP}] )
"
BDEPEND="${PYTHON_DEPS}"

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/klipper-${COMMIT_HASH}/* "${S}"/ || die
	rm -r "${WORKDIR}"/klipper-${COMMIT_HASH} || die

	if use eddy-ng; then
		cp "${WORKDIR}/eddy-ng-${EDDY_NG_COMMIT_HASH}/eddy-ng/sensor_ldc1612_ng.c" "${S}/src/"

		cp "${WORKDIR}/eddy-ng-${EDDY_NG_COMMIT_HASH}/probe_eddy_ng.py" "${S}/klippy/extras/"
		cp "${WORKDIR}/eddy-ng-${EDDY_NG_COMMIT_HASH}/ldc1612_ng.py" "${S}/klippy/extras/"
	fi
}

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	if use source; then
		elog "Fixing Makefile's to use crossdev toolchain"
		find "${S}/src/" -type f -name 'Makefile' -exec sed -i 's/-lc_nano/-lc_nano -lnosys/g' {} + || die
	fi

	if use eddy-ng; then
		sed -i 's,sensor_ldc1612.c$,sensor_ldc1612.c sensor_ldc1612_ng.c,' "${S}/src/Makefile" || die
		sed -i 's,probe_name.startswith(\"probe_eddy_current\"),\"eddy\" in probe_name #eddy-ng,' "${S}/klippy/extras/bed_mesh.py" || die
	fi

	python_foreach_impl python_fix_shebang --force klippy/
	python_foreach_impl python_fix_shebang --force scripts/
}

src_compile() {
	# Trigger building native helper
	PYTHONPATH="$(pwd)/klippy" python -c "import chelper; chelper.get_ffi()"
}

src_install() {
	use doc && docompress -x usr/share/doc/${PF}/docs
	use doc && dodoc -r "${S}"/docs
	use doc && docompress -x usr/share/doc/${PF}/config
	use doc && dodoc -r "${S}"/config

	insinto usr/libexec/klipper/
	doins -r klippy/
	fperms 0755 usr/libexec/klipper/klippy/klippy.py
	fperms 0755 usr/libexec/klipper/klippy/console.py
	fperms 0755 usr/libexec/klipper/klippy/parsedump.py
	use doc && dosym ../../share/doc/${PF}/docs usr/libexec/klipper/docs
	use doc && dosym ../../share/doc/${PF}/config usr/libexec/klipper/config
	fowners klipper:klipper usr/libexec/klipper/

	newinitd "${FILESDIR}"/klipper.initd klipper
	newconfd "${FILESDIR}"/klipper.confd klipper

	dodir etc/klipper
	fowners klipper:klipper etc/klipper
	insinto etc/klipper
	newins config/example.cfg printer.cfg
	fowners klipper:klipper etc/klipper/printer.cfg

	if use source; then
		insinto usr/src/klipper-sources/
		doins COPYING
		doins -r lib/
		doins Makefile
		doins README.md
		doins -r scripts/
		doins -r src/
		dosym ../../libexec/klipper/klippy usr/src/klipper-sources/klippy
		use doc && dosym ../../share/doc/${PF}/docs usr/src/klipper-sources/docs
		use doc && dosym ../../share/doc/${PF}/config usr/src/klipper-sources/config
		fowners klipper:klipper usr/src/klipper-sources
		fperms 0755 usr/src/klipper-sources/scripts/check-gcc.sh
	fi
}

pkg_postinst() {
	if use source; then
		elog "To compile firmware:"
		elog "    - Run 'echo "cross-arm-none-eabi/newlib nano" >> /etc/portage/package.use/newlib'"
		elog "    - Install ARM toolchain: 'crossdev -s3 -S --target arm-none-eabi'"
		elog "(Stage 3 of toolchain is enough to compile Klipper)"
	fi
}
