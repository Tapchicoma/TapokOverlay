# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="A Python parser for parsing multipart/form-data input chunks"
HOMEPAGE="https://github.com/siddhantgoel/streaming-form-data"
SRC_URI="https://github.com/siddhantgoel/streaming-form-data/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	use doc && dodoc -r "${S}"/docs
}
