# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-3.4.0.ebuild,v 1.1 2013/09/24 22:51:43 anarchy Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~x64-macos"
IUSE="debug static-libs stats"

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-3.5.0-strip-optimization.patch" \
		"${FILESDIR}/${PN}-3.5.0-no-pprof.patch" \
		"${FILESDIR}/${PN}-3.5.0_fix_html_install.patch"

	eautoreconf
}

src_configure() {
	# https://github.com/jemalloc/jemalloc/issues/48
	EXTRA_CFLAGS="-std=gnu99" econf \
		$(use_enable debug) \
		$(use_enable stats)
}

src_install() {
	default
	dohtml doc/jemalloc.html

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libjemalloc.1.dylib \
			"${ED}"/usr/$(get_libdir)/libjemalloc.1.dylib || die
	fi
	use static-libs || find "${ED}" -name '*.a' -delete
}