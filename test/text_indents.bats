
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "TEXT_INDENTS: Should exist be empty on init" {
	[[ ${#TEXT_INDENTS[@]} -eq 0 ]]
}

@test "push_text_indent: Should add values to tail of TEXT_INDENTS arary" {
	push_text_indent "ONE"

	[[ ${#TEXT_INDENTS[@]} -eq  1    ]]
	[[ "${TEXT_INDENTS[0]}" == "ONE" ]]

	push_text_indent "TWO"
	[[ ${#TEXT_INDENTS[@]} -eq  2    ]]
	[[ "${TEXT_INDENTS[0]}" == "ONE" ]]
	[[ "${TEXT_INDENTS[1]}" == "TWO" ]]
}

@test "pop_text_indent: Should remove values from tail of TEXT_INDENTS array" {
	push_text_indent "ONE"
	push_text_indent "TWO"
	[[ ${#TEXT_INDENTS[@]} -eq  2    ]]
	[[ "${TEXT_INDENTS[0]}" == "ONE" ]]
	[[ "${TEXT_INDENTS[1]}" == "TWO" ]]

	pop_text_indent
	[[ ${#TEXT_INDENTS[@]} -eq  1    ]]
	[[ "${TEXT_INDENTS[0]}" == "ONE" ]]

	pop_text_indent
	[[ ${#TEXT_INDENTS[@]} -eq  0    ]]
}

@test "pop_text_indent: Should not generate error when TEXT_INDENTS array is empty" {
	[[ ${#TEXT_INDENTS[@]} -eq  0 ]]

	pop_text_indent
	[[ ${#TEXT_INDENTS[@]} -eq  0 ]]

	pop_text_indent
	[[ ${#TEXT_INDENTS[@]} -eq  0 ]]
}
