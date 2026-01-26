# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit python-r1

COMMIT_HASH="e60fe3d99b545d7e42ff2f5278efa5822668a57c"
DESCRIPTION="The Klipper service to control 3d-Printers."
HOMEPAGE="https://www.klipper3d.org/"
SRC_URI="https://github.com/Klipper3d/klipper/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="doc inputshaper"

RDEPEND="${PYTHON_DEPS}
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	acct-group/klipper
	acct-user/klipper
	inputshaper? ( dev-python/numpy[${PYTHON_USEDEP}] )
	inputshaper? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
"
BDEPEND="${PYTHON_DEPS}"

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/klipper-${COMMIT_HASH}/* "${S}"/ || die
	rm -r "${WORKDIR}"/klipper-${COMMIT_HASH} || die
}

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	python_foreach_impl python_fix_shebang --force klippy/
}

src_compile() {
	# Trigger building native helper
	PYTHONPATH="$(pwd)/klippy" python -c "import chelper; chelper.get_ffi()"
}

src_install() {
	use doc && dodoc -r "${S}"/docs
	use doc && dodoc -r "${S}"/config

	insinto /usr/libexec/klipper/
	doins -r klippy/
	fperms 0755 /usr/libexec/klipper/klippy/klippy.py
	fperms 0755 /usr/libexec/klipper/klippy/console.py
	fperms 0755 /usr/libexec/klipper/klippy/parsedump.py
	fowners klipper:klipper /usr/libexec/klipper/

	newinitd "${FILESDIR}"/klipper.initd klipper
	newconfd "${FILESDIR}"/klipper.confd klipper

	dodir /etc/klipper
	fowners klipper:klipper /etc/klipper
	insinto /etc/klipper
	newins config/example.cfg printer.cfg
	fowners klipper:klipper /etc/klipper/printer.cfg
}
