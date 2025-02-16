# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit python-r1

DESCRIPTION="The Klipper service to control 3d-Printers."
HOMEPAGE="https://www.klipper3d.org/"
SRC_URI="https://github.com/Klipper3d/klipper/archive/fec3e685c92ef263a829a73510c74245d7772c03.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="doc"

RDEPEND="${PYTHON_DEPS}
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	acct-group/klipper
	acct-user/klipper
"
BDEPEND="${PYTHON_DEPS}"

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/klipper-fec3e685c92ef263a829a73510c74245d7772c03/* "${S}"/ || die
	rm -r "${WORKDIR}"/klipper-fec3e685c92ef263a829a73510c74245d7772c03 || die
}

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	python_foreach_impl python_fix_shebang --force klippy/
}

src_compile() {
	true
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

	insinto /etc/klipper
	newins config/example.cfg /etc/klipper/printer.cfg
	fowners klipper:klipper /etc/klipper
	fowners klipper:klipper /etc/klipper/printer.cfg
}
