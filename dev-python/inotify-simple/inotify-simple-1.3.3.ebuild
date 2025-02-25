# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

DESCRIPTION="Simple Python wrapper around inotify"
HOMEPAGE="https://github.com/chrisjbillington/inotify_simple"
SRC_URI="https://github.com/chrisjbillington/inotify_simple/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/inotify_simple-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64"
RESTRICT="test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
