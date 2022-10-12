#!/usr/bin/env bash
pushd test/tpl >> /dev/null
exec > tpl.bats
printf "%s\n" \#\ NOTE:\ BATS_TEST_DIRNAME\ =\>\ BASH_TPL_ROOT/test/tpl
printf "%s\n" \#
printf "\n"
printf "%s\n" setup\(\)\ \{
	printf "%s\n" $'\tload ../lib/diff'
	printf "%s\n" $'\tsource "${BATS_TEST_DIRNAME}/../../bash-tpl"'
printf "%s\n" \}
printf "\n"
printf "%s\n" \##
printf "%s\n" \#\ test_template
printf "%s\n" \#\ \$1\ =\ template\ basename\ \(no\ path\)
printf "%s\n" \#\ Assumed\ to\ be\ relative\ to\ test/tpl
printf "%s\n" \#
printf "%s\n" test_template\(\)\ \{
	printf "%s\n" $'\tpushd "${BATS_TEST_DIRNAME}" >> /dev/null'
	printf "%s\n" $'\trun main "${BATS_TEST_DIRNAME}/${1}"'
	printf "%s\n" $'\tdiff_output_file "${BATS_TEST_DIRNAME}/${1%.tpl}.sh"'
	printf "%s\n" $'\tpopd >> /dev/null'
printf "%s\n" \}
_fix_nullglob=$(shopt -p nullglob || true)
shopt -s nullglob
for tpl in *.tpl; do
	printf "\n"
	printf "%s\n" @test\ \"tpl:\ Should\ render\ test/tpl/"$tpl"\ to\ match\ test/tpl/"${tpl%.tpl}.sh"\ \{
		printf "%s\n" $'\ttest_template "'"$tpl"\"
	printf "%s\n" \}
done
eval "${_fix_nullglob}"
popd >> /dev/null
