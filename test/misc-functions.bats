
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
	local value

	value=''
	escape_regex value
	[[ "${value}" == '' ]]

	value=' '
	escape_regex value
	[[ "${value}" == ' ' ]]

	value='  '
	escape_regex value
	[[ "${value}" == '  ' ]]

	value='abcABC123_-'
	escape_regex value
	[[ "${value}" == 'abcABC123_-' ]]

	value='][\.|$(){}?+*^'
	escape_regex value
	[[ "${value}" == '\]\[\\\.\|\$\(\)\{\}\?\+\*\^' ]]

	value='{}'
	escape_regex value
	[[ "${value}" == '\{\}' ]]

	value=' . '
	escape_regex value
	[[ "${value}" == ' \. ' ]]
}

@test "misc-function: normalize_directive" {
	local value

	value=''
	normalize_directive value
	[[ "${value}" == '' ]]

	value=' '
	normalize_directive value
	[[ "${value}" == ' ' ]]

	value='  '
	normalize_directive value
	[[ "${value}" == '  ' ]]

	value='abc_ABC-123'
	normalize_directive value
	[[ "${value}" == 'ABC-ABC-123' ]]

	value=' _ '
	normalize_directive value
	[[ "${value}" == ' - ' ]]
}
