# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6}} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Tools to supplement packaging Python releases"
HOMEPAGE="https://github.com/jaraco/jaraco.packaging"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="doc test"

RDEPEND=">=dev-python/six-1.4[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.9[${PYTHON_USEDEP}]
	doc? (
		dev-python/rst-linker[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
		cd docs || die
		sphinx-build . _build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Skip one test which requires network access
	PYTHONPATH=. py.test -v -k "not test_revived_distribution" \
		|| die "tests failed with ${EPYTHON}"
}
