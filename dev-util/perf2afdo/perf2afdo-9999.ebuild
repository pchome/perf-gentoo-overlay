# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="System to simplify real-world deployment of feedback-directed optimization"
HOMEPAGE="https://github.com/google/autofdo"

if [[ ${PV} == "9999" ]] ; then
        EGIT_REPO_URI="https://github.com/pchome/${PN}.git"
        EGIT_BRANCH="master"
        inherit git-r3
        SRC_URI=""
else
        ECOMMIT="a65d80a82054ac31bbd862adfbd67a3ed263ae86"
        SRC_URI="https://github.com/pchome/${PN}/archive/${ECOMMIT}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="~amd64 ~x86"
        S="${WORKDIR}/${PN}-${ECOMMIT}"
fi


LICENSE="Apache-2.0"
SLOT="0"
IUSE="lbr libressl llvm elibc_uclibc"

RESTRICT+=" mirror test"


RDEPEND="dev-libs/protobuf:0=
	virtual/libelf
	dev-cpp/gflags
	dev-cpp/glog
	!elibc_uclibc? ( dev-libs/elfutils )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/PERF_RECORD_SAMPLE.patch"
)

afdo_check_requirements() {
    if [[ ${MERGE_TYPE} != binary ]]; then
        if ! tc-is-gcc || [[ $(gcc-major-version) -lt 5 || $(gcc-major-version) -eq 5 && $(gcc-minor-version) -lt 1 ]]; then
            die "At least gcc 5.1 is required"
        fi
    fi
}

pkg_pretend() {
    afdo_check_requirements
}

pkg_setup() {
    afdo_check_requirements
}

src_configure() {
    local emesonargs=(
        $(meson_use lbr use_lbr)
        $(meson_use llvm enable_llvm)
        --unity=on
    )
    meson_src_configure
}

