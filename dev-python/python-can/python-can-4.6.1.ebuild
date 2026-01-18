# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

DESCRIPTION="Controller area network support for Python "
HOMEPAGE="https://github.com/hardbyte/python-can"
SRC_URI="https://github.com/hardbyte/python-can/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/python-can-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64"
RESTRICT="test"

RDEPEND="
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

python_prepare_all() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
	distutils-r1_python_prepare_all
}
