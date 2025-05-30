# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
# Missing parts:
# - gcode_shell_command as klipper extension
# - system_info command
# - shaketune
# - adapt moonraker scripts

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit python-r1

DESCRIPTION="Klippain is a customizable Klipper configuration for 3D printers."
HOMEPAGE="https://github.com/Frix-x/klippain"
SRC_URI="https://github.com/Frix-x/klippain/archive/ce8626ce81b0c7dbddee9b3861d518c28ed5682f.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="arm arm64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="moonraker"

RESTRICT="strip test"

RDEPEND="
	${PYTHON_DEPS}
	dev-embedded/klipper
	moonraker? ( dev-embedded/moonraker )
"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_setup
}

src_unpack() {
	default

	mkdir "${S}"
	mv "${WORKDIR}"/klippain-ce8626ce81b0c7dbddee9b3861d518c28ed5682f/* "${S}"/ || die
	rm -r "${WORKDIR}"/klippain-ce8626ce81b0c7dbddee9b3861d518c28ed5682f || die
}

src_prepare() {
	default

	python_foreach_impl python_fix_shebang --force scripts/
}

src_install() {
	dodoc -r docs/
	insinto /usr/share/klippain
	doins -r config/
	doins -r macros/
	doins -r scripts/
	doins -r user_templates/
	use moonraker && doins -r moonraker/

	dosym ../../usr/share/klippain/config /etc/klipper/config
	dosym ../../usr/share/klippain/macros /etc/klipper/macros
	dosym ../../usr/share/klippain/scripts /etc/klipper/scripts

	insinto /etc/klipper
	insopts -g klipper -o klipper
	doins user_templates/mcu.cfg
	doins user_templates/overrides.cfg
	newins user_templates/printer.cfg klippain_printer.cfg
	doins user_templates/save_variables.cfg
	doins user_templates/variables.cfg

	if use moonraker; then
		dosym ../../usr/share/klippain/moonraker /etc/moonraker/moonraker
		insinto /etc/moonraker
		newins user_templates/moonraker.conf moonraker_klippain.conf
		fowners klipper:klipper /etc/moonraker/
	fi

	elog "Check /usr/share/klippain/user_templates/mcu_defaults for known MCU configurations."
}
