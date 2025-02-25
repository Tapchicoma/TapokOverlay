# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517="pdm-backend"
export PDM_BUILD_SCM_VERSION="$PV"

inherit distutils-r1

DESCRIPTION="API Web Server for Klipper"
HOMEPAGE="https://github.com/Arksine/moonraker/"
SRC_URI="https://github.com/Arksine/moonraker/archive/62051108ea16d5db5fa382651e01a51d89c041c9.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm arm64"
RESTRICT="test"

# dev-python/dbus-fast is missing arm64 keyword
RDEPEND="
	dev-embedded/klipper:=
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/libnacl[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	dev-python/streaming-form-data[${PYTHON_USEDEP}]
	dev-python/dbus-fast[${PYTHON_USEDEP}]
	dev-python/inotify-simple[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/pdm-backend[${PYTHON_USEDEP}]
"

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/moonraker-62051108ea16d5db5fa382651e01a51d89c041c9/* "${S}"/ || die
	rm -r "${WORKDIR}"/moonraker-62051108ea16d5db5fa382651e01a51d89c041c9 || die
}

python_install() {
	distutils-r1_python_install

	newinitd "${FILESDIR}"/moonraker.initd moonraker
	newconfd "${FILESDIR}"/moonraker.confd moonraker

	dodir /etc/moonraker
	fowners klipper:klipper /etc/moonraker
	insinto /etc/moonraker
	newins "${FILESDIR}/default_config" moonraker.conf
	fowners klipper:klipper /etc/moonraker/moonraker.conf
}
