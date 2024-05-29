
setup() {
	bats_require_minimum_version 1.7.0
	# shellcheck source=../bash-tpl
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "TEXT_INDENT: Should exist and be set to '' on init" {
	[[ "${TEXT_INDENT-.}" == "" ]]
}

@test "TEXT_INDENTS: Should exist and be empty on init" {
	[[ ${#TEXT_INDENTS[@]} -eq 0 ]]
}

@test "push_text_indent: Should add current TEXT_INDENT to tail of TEXT_INDENTS array, set TEXT_INDENT to new value" {
	push_text_indent "ONE"
	[[ ${TEXT_INDENT}       == "ONE" ]]
	[[ ${#TEXT_INDENTS[@]} -eq  1    ]]
	[[ "${TEXT_INDENTS[0]}" == ""    ]]

	push_text_indent "TWO"
	[[ ${TEXT_INDENT}       == "TWO" ]]
	[[ ${#TEXT_INDENTS[@]} -eq  2    ]]
	[[ "${TEXT_INDENTS[0]}" == ""    ]]
	[[ "${TEXT_INDENTS[1]}" == "ONE" ]]
}

@test "pop_text_indent: Should remove tail of TEXT_INDENTS array, setting TEXT_INDENT to removed value" {
	push_text_indent "ONE"
	push_text_indent "TWO"
	[[ ${TEXT_INDENT}       == "TWO" ]]
	[[ ${#TEXT_INDENTS[@]} -eq  2    ]]
	[[ "${TEXT_INDENTS[0]}" == ""    ]]
	[[ "${TEXT_INDENTS[1]}" == "ONE" ]]

	pop_text_indent
	[[ ${TEXT_INDENT}       == "ONE" ]]
	[[ ${#TEXT_INDENTS[@]} -eq  1    ]]
	[[ "${TEXT_INDENTS[0]}" == ""    ]]

	pop_text_indent
	[[ ${TEXT_INDENT}       == ""    ]]
	[[ ${#TEXT_INDENTS[@]} -eq  0    ]]
}

@test "pop_text_indent: Should set TEXT_INDENT to '', should not generate error when TEXT_INDENTS array is empty" {
	[[ ${TEXT_INDENT}       == "" ]]
	[[ ${#TEXT_INDENTS[@]} -eq  0 ]]

	TEXT_INDENT="."
	pop_text_indent
	[[ ${TEXT_INDENT}       == "" ]]
	[[ ${#TEXT_INDENTS[@]} -eq  0 ]]

	TEXT_INDENT="."
	pop_text_indent
	[[ ${TEXT_INDENT}       == "" ]]
	[[ ${#TEXT_INDENTS[@]} -eq  0 ]]
}
