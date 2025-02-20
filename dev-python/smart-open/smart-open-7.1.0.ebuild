# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

DESCRIPTION="Utils for streaming large files in Python"
HOMEPAGE="https://github.com/piskvorky/smart_open"
SRC_URI="https://github.com/piskvorky/smart_open/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/smart_open-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64"
RESTRICT="test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
