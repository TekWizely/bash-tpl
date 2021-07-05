
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "misc-function: trim" {
	local value

	value=""
	trim value
	[[ "${value}" == "" ]]

	value=" "
	trim value
	[[ "${value}" == "" ]]

	value="  "
	trim value
	[[ "${value}" == "" ]]

	value=" . "
	trim value
	[[ "${value}" == "." ]]

	value="  .  "
	trim value
	[[ "${value}" == "." ]]

	value=" . . "
	trim value
	[[ "${value}" == ". ." ]]

	value="  . .  "
	trim value
	[[ "${value}" == ". ." ]]

	value=$'\t'
	trim value
	[[ "${value}" == "" ]]

	value=$'\t\t'
	trim value
	[[ "${value}" == "" ]]

	value=$'\t.\t'
	trim value
	[[ "${value}" == "." ]]

	value=$'\t . \t'
	trim value
	[[ "${value}" == "." ]]

	value=$'\t.\t.\t'
	trim value
	[[ "${value}" == $'.\t.' ]]

	value=$' \t. \t . \t'
	trim value
	[[ "${value}" == $'. \t .' ]]

	value=$'\x01'
	trim value
	[[ "${value}" == $'\x01' ]]

	value=$' \x7f\t'
	trim value
	[[ "${value}" == $'\x7f' ]]

	value=$'  \x7f\t\t'
	trim value
	[[ "${value}" == $'\x7f' ]]

	value=$'\t \x01\t \x7f \t'
	trim value
	[[ "${value}" == $'\x01\t \x7f' ]]
}

@test "misc-function: escape_regex" {

	run escape_regex ''
	[[ "${output}" == '' ]]

	run escape_regex ' '
	[[ "${output}" == ' ' ]]

	run escape_regex '  '
	[[ "${output}" == '  ' ]]

	run escape_regex 'abcABC123_-'
	[[ "${output}" == 'abcABC123_-' ]]

	run escape_regex '][\.|$()?+*^'
	[[ "${output}" == '\]\[\\\.\|\$\(\)\?\+\*\^' ]]

	run escape_regex '{}'
	[[ "${output}" == '{}' ]]

	run escape_regex ' . '
	[[ "${output}" == ' \. ' ]]
}

@test "misc-function: normalize_directive" {
	run normalize_directive ''
	[[ "${output}" == '' ]]

	run normalize_directive ' '
	[[ "${output}" == ' ' ]]

	run normalize_directive '  '
	[[ "${output}" == '  ' ]]

	run normalize_directive 'abc_ABC-123'
	[[ "${output}" == 'ABC-ABC-123' ]]

	run normalize_directive ' _ '
	[[ "${output}" == ' - ' ]]
}
