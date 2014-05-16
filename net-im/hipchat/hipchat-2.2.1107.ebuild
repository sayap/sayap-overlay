EAPI=5

inherit gnome2-utils

DESCRIPTION="HipChat is hosted group chat and video chat built for teams"
HOMEPAGE="http://www.hipchat.com/"
SRC_URI="amd64? ( http://downloads.hipchat.com/linux/arch/x86_64/${P}-x86_64.pkg.tar.xz )
	x86? ( http://downloads.hipchat.com/linux/arch/i686/${P}-i686.pkg.tar.xz )"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

S="${WORKDIR}"

RESTRICT="mirror strip"
QA_PREBUILT="opt/HipChat/lib/*"

src_prepare() {
	sed -i \
		-e "s|hipchat.png|hipchat|" \
		-e "s|Terminal=0|Terminal=false|" \
		usr/share/applications/hipchat.desktop
}

src_install() {
	doins -r opt
	doins -r usr

	chmod 755 "${D}"/opt/HipChat/bin/*
	chmod 755 "${D}"/opt/HipChat/lib/hipchat.bin
	chmod 755 "${D}"/opt/HipChat/lib/kurasshu
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
