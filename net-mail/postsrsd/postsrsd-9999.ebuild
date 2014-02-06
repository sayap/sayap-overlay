EAPI="5"

EGIT_REPO_URI="git://github.com/roehling/postsrsd.git"
EGIT_PROJECT="roehling/postsrsd"

inherit cmake-utils eutils git-2

DESCRIPTION="A daemon to provide Sender Rewriting Scheme (SRS) for Postfix"
HOMEPAGE="https://github.com/roehling/postsrsd"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	cmake-utils_src_install

	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
}

pkg_postinst() {
	einfo "Set the domain in /etc/conf.d/postsrsd, and add this fragment "
	einfo "to /etc/postfix/main.cf:"
	einfo ""
	einfo "sender_canonical_maps = tcp:127.0.0.1:10001"
	einfo "sender_canonical_classes = envelope_sender"
	einfo "recipient_canonical_maps = tcp:127.0.0.1:10002"
	einfo "recipient_canonical_classes = envelope_recipient"
}
