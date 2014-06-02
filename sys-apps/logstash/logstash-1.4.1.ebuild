# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils systemd

DESCRIPTION="a tool for managing events and logs."
HOMEPAGE="http://logstash.net/"
SRC_URI="https://download.elasticsearch.org/${PN}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="systemd"

RDEPEND="virtual/jre"

DEPEND="${RDEPEND}
	systemd? ( sys-apps/systemd )"

src_install() {
	insinto /etc/${PN}/conf.d
	doins "${FILESDIR}/agent.conf.sample"

	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	dodir "/opt/${PN}"
	cp -R "${S}"/* "${D}/opt/${PN}" || die "Install failed!"

	dodir /etc/logrotate.d
	cp ${FILESDIR}/logstash.logrotate ${D}/etc/logrotate.d/${PN} \
	|| die "failed copying lograte file into place"

	newconfd "${FILESDIR}/${PN}.conf-r1" "${PN}"
	newinitd "${FILESDIR}/${PN}.init-r1" "${PN}"

	if use systemd; then
		systemd_dounit "${FILESDIR}"/${PN}-agent.service
		systemd_dounit "${FILESDIR}"/${PN}-web.service
	fi
}

pkg_postinst() {
	einfo "some useful links for getting started"
	einfo "  https://github.com/logstash/logstash/wiki"
	einfo "  http://cookbook.logstash.net/"
	einfo "  http://www.logstash.net/docs/${PV}/"
	einfo "  https://github.com/logstash/logstash/tree/v${PV}/patterns"
}
