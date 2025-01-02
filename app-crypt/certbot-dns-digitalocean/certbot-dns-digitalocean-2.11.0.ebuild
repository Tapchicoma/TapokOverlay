# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Digitalocean DNS Authenticator plugin for Certbot (Let's Encrypt Client)"
HOMEPAGE="
		https://github.com/certbot/certbot
		https://letsencrypt.org/
"
SRC_URI="https://github.com/certbot/certbot/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/certbot-${PV}/${PN}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	 >=app-crypt/certbot-${PV}[${PYTHON_USEDEP}]
	 >=dev-python/digitalocean-1.11-r0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/alabaster
distutils_enable_tests pytest
