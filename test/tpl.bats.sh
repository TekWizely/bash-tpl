#!/usr/bin/env bash
pushd test/tpl >> /dev/null
exec > tpl.bats
printf "%b\n" '# NOTE: BATS_TEST_DIRNAME => BASH_TPL_ROOT/test/tpl'
printf "%b\n" '#'
printf "\n"
printf "%b\n" 'setup() {'
printf "%b\n" '\tbats_require_minimum_version 1.7.0'
printf "%b\n" '\tload ../lib/diff'
printf "%b\n" '\t# shellcheck source=../../bash-tpl'
printf "%b\n" '\tsource "${BATS_TEST_DIRNAME}/../../bash-tpl"'
printf "%b\n" '}'
printf "\n"
printf "%b\n" '##'
printf "%b\n" '# test_template'
printf "%b\n" '# $1 = template basename (no path)'
printf "%b\n" '# Assumed to be relative to test/tpl'
printf "%b\n" '#'
printf "%b\n" 'test_template() {'
printf "%b\n" '\tpushd "${BATS_TEST_DIRNAME}" >> /dev/null'
printf "%b\n" '\tlocal separate_stderr='
printf "%b\n" '\t# Does test include check for stderr?'
printf "%b\n" '\tif [ -f  "${BATS_TEST_DIRNAME}/${1%.tpl}.stderr" ]; then'
printf "%b\n" '\t\tseparate_stderr=\0047--separate-stderr\0047'
printf "%b\n" '\tfi'
printf "%b\n" '\trun ${separate_stderr} -- main "${BATS_TEST_DIRNAME}/${1}"'
printf "%b\n" '\t[[ $status = 0 ]]'
printf "%b\n" '\tdiff_output_file "${BATS_TEST_DIRNAME}/${1%.tpl}.sh"'
printf "%b\n" '\tif [ "${output_type}" = "separate" ]; then'
printf "%b\n" '\t\tdiff_stderr_file "${BATS_TEST_DIRNAME}/${1%.tpl}.stderr"'
printf "%b\n" '\tfi'
printf "%b\n" '\trun bash "${BATS_TEST_DIRNAME}/${1%.tpl}.sh"'
printf "%b\n" '\tdiff_output_file "${BATS_TEST_DIRNAME}/${1%.tpl}.txt"'
printf "%b\n" '\tpopd >> /dev/null'
printf "%b\n" '}'
_fix_nullglob=$(shopt -p nullglob || true)
shopt -s nullglob
for tpl in *.tpl; do
	printf "\n"
	printf "%b\n" '@test "tpl: Should render test/tpl/'"$tpl"' to match test/tpl/'"${tpl%.tpl}.sh"' {'
	printf "%b\n" '\ttest_template "'"$tpl"'"'
	printf "%b\n" '}'
done
eval "${_fix_nullglob}"
popd >> /dev/null
