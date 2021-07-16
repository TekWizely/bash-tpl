%
#!/usr/bin/env bash
pushd test/tpl >> /dev/null
exec > tpl.bats
%
# NOTE: BATS_TEST_DIRNAME => BASH_TPL_ROOT/test/tpl
#

setup() {
	load ../lib/diff
	source "${BATS_TEST_DIRNAME}/../../bash-tpl"
}

##
# test_template
# $1 = template basename (no path)
# Assumed to be relative to test/tpl
#
test_template() {
	pushd "${BATS_TEST_DIRNAME}" >> /dev/null
	run main "${BATS_TEST_DIRNAME}/${1}"
	diff_output_file "${BATS_TEST_DIRNAME}/${1%.tpl}.sh"
	popd >> /dev/null
}
% _fix_nullglob=$(shopt -p nullglob || true)
% shopt -s nullglob
% for tpl in *.tpl; do
	%# blank space below is intentional

	@test "tpl: Should render test/tpl/<% $tpl %> to match test/tpl/<%"${tpl%.tpl}.sh"%> {
		test_template "<% $tpl %>"
	}
% done
% eval "${_fix_nullglob}"
% popd >> /dev/null
