# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN//-/_}"

DESCRIPTION="Convert Linux perf files to the profile.proto format used by pprof"
HOMEPAGE="https://github.com/google/${MY_PN}"

if [[ ${PV} == "9999" ]] ; then
        EGIT_REPO_URI="https://github.com/google/perf_data_converter.git"
        EGIT_BRANCH="master"
        inherit git-r3
        SRC_URI=""
else
	ECOMMIT="fdc658410dfa9d01b906b115e6fef35c308e55e1"
	SRC_URI="https://github.com/google/${MY_PN}/archive/${ECOMMIT}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="~amd64 ~x86"
        S="${WORKDIR}/${MY_PN}-${ECOMMIT}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="debug test libressl elibc_uclibc"

RESTRICT+=" mirror"


RDEPEND="dev-libs/protobuf:0=
	!elibc_uclibc? ( dev-libs/elfutils )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# remove bundled libs
	rm -r third_party || die
}

src_compile() {
	cd src
	emake
}

src_install() {
	cd src
	dobin perf_to_profile
}
