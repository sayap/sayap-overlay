EAPI=2

DESCRIPTION="a C client and protocol library for the Drizzle project"
HOMEPAGE="http://launchpad.net/libdrizzle"
SRC_URI="http://agentzh.org/misc/nginx/drizzle7-2011.07.21.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tcmalloc +sqlite"

RDEPEND="!dev-db/drizzle
	tcmalloc? ( dev-util/google-perftools )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

src_prepare() {
	mv drizzle7-2011.07.21 ${P}
	cp "${FILESDIR}"/PROTOCOL ${P}
}

src_configure() {
	# Don't ever use --enable-assert since configure.ac is broken, and
	# only does --disable-assert correctly.
	if use debug; then
		# Since --with-debug would turn off optimisations as well as
		# enabling debug, we just enable debug through the
		# preprocessor then.
		append-flags -DDEBUG

	# Right now disabling asserts break the code, so never disable
	# them as it is.
	#else
	#	myconf="${myconf} --disable-assert"
	fi

	econf \
		--without-server \
		--disable-static \
		--disable-dependency-tracking \
		--disable-mtmalloc \
		$(use_enable tcmalloc) \
		$(use_enable sqlite libsqlite3)
}

src_compile() {
	emake libdrizzle-1.0 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install-libdrizzle-1.0 || die "install failed"
	dodoc AUTHORS ChangeLog NEWS PROTOCOL README || die

	find "${D}" -name '*.la' -delete || die
}
