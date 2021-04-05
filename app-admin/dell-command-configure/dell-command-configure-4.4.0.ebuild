# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Dell command line utility to configure BIOS features."
HOMEPAGE="https://www.dell.com/support/kbdoc/en-us/000178000/dell-command-configure?lang=en"
SRC_URI="https://dl.dell.com/FOLDER06874341M/1/command-configure_${PV}-86.ubuntu20_amd64.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror bindist strip"

RDEPEND="
	sys-libs/libsmbios
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

QA_PREBUILT="
	opt/dell/dcc/cctk
	opt/dell/dcc/libhapiintf.so
	opt/dell/srvadmin/etc/omreg.d/omreg-hapi.cfg
	opt/dell/srvadmin/etc/srvadmin-hapi/ini/dchipm.ini
	opt/dell/srvadmin/lib64/libdchapi.so.9.3.0
	opt/dell/srvadmin/lib64/libdchbas.so.9.3.0
	opt/dell/srvadmin/lib64/libdchcfl.so.9.3.0
	opt/dell/srvadmin/lib64/libdchesm.so.9.3.0
	opt/dell/srvadmin/lib64/libdchipm.so.9.3.0
	opt/dell/srvadmin/lib64/libdchtvm.so.9.3.0
"

src_prepare() {
	default

	unpack_deb command-configure_${PV}-86.ubuntu20_amd64.deb
	unpack_deb srvadmin-hapi_9.3.0_amd64.deb
	rm *.deb
	rm opt/dell/dcc/*.desktop
	echo "/opt/dell/srvadmin/lib64/" >> 99-${PN}.conf
}

src_install() {
	exeinto /opt/dell/dcc/
	doexe opt/dell/dcc/cctk
	dosym ../../opt/dell/dcc/cctk opt/bin/cctk

	insinto /opt/dell/srvadmin/lib64/
	doins opt/dell/dcc/libhapiintf.so
	doins -r opt/dell/srvadmin/lib64/*.so.*

	insinto /opt/dell/srvadmin/etc/
	doins -r opt/dell/srvadmin/etc/*
	newins opt/dell/srvadmin/etc/omreg.d/omreg-hapi.cfg omreg.cfg

	insinto /etc/ld.so.conf.d/
	doins 99-${PN}.conf
}
