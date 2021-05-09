# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISUTILS_USE_SETUPTOOLS=rdepend
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
DOCS=( ../README.md ../Documentation/git-filter-repo.txt )

inherit distutils-r1

DESCRIPTION="Quickly rewrite git repository history"
HOMEPAGE="https://github.com/newren/git-filter-repo"
SRC_URI="https://github.com/newren/git-filter-repo/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${P}/release

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
