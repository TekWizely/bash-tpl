
setup() {
	load lib/diff
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

# NOTE: We do not auto re-gen tpl.bats.sh because a failure
#       here could suggest a breaking change in bash-tpl
#
@test "tpl.bats.sh: Check if tpl.bats.sh is outdated" {
	pushd "${BATS_TEST_DIRNAME}" > /dev/null
	run main "${BATS_TEST_DIRNAME}/tpl.bats.tpl"
	diff_output_file "${BATS_TEST_DIRNAME}/tpl.bats.sh"
	popd > /dev/null
}

@test "tpl.bats: Should generate new copy of test/tpl.bats" {
	# Remove existing copy, if present
	#
	rm -f "${BATS_TEST_DIRNAME}/tpl/tpl.bats"
	[[ ! -f "${BATS_TEST_DIRNAME}/tpl/tpl.bats" ]]

	# Create new test suite against current tpl files
	#
	"${BATS_TEST_DIRNAME}/tpl.bats.sh" > "${BATS_TEST_DIRNAME}/tpl/tpl.bats"
	[[ -f "${BATS_TEST_DIRNAME}/tpl/tpl.bats" ]]
}
