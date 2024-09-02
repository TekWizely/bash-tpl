%
#!/usr/bin/env bash
pushd test/tpl >> /dev/null
exec > tpl.bats
%
# NOTE: BATS_TEST_DIRNAME => BASH_TPL_ROOT/test/tpl
#

setup() {
	bats_require_minimum_version 1.7.0
	load ../lib/diff
	# shellcheck source=../../bash-tpl
	source "${BATS_TEST_DIRNAME}/../../bash-tpl"
}

##
# test_template
# $1 = template basename (no path)
# Assumed to be relative to test/tpl
#
test_template() {
	pushd "${BATS_TEST_DIRNAME}" >> /dev/null
	local separate_stderr=
	# Does test include check for stderr?
	if [ -f  "${BATS_TEST_DIRNAME}/${1%.tpl}.stderr" ]; then
		separate_stderr='--separate-stderr'
	fi
	run ${separate_stderr} -- main "${BATS_TEST_DIRNAME}/${1}"
	[[ $status = 0 ]]
	diff_output_file "${BATS_TEST_DIRNAME}/${1%.tpl}.sh"
	if [ "${output_type}" = "separate" ]; then
		diff_stderr_file "${BATS_TEST_DIRNAME}/${1%.tpl}.stderr"
	fi
	run bash "${BATS_TEST_DIRNAME}/${1%.tpl}.sh"
	diff_output_file "${BATS_TEST_DIRNAME}/${1%.tpl}.txt"
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
