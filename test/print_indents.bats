
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "PRINT_INDENTS: Should exist be empty on init" {
	[[ ${#PRINT_INDENTS[@]} -eq 0 ]]
}

@test "push_print_indent: Should add values to tail of PRINT_INDENTS arary" {
	push_print_indent "ONE"

	[[ ${#PRINT_INDENTS[@]} -eq  1    ]]
	[[ "${PRINT_INDENTS[0]}" == "ONE" ]]

	push_print_indent "TWO"
	[[ ${#PRINT_INDENTS[@]} -eq  2    ]]
	[[ "${PRINT_INDENTS[0]}" == "ONE" ]]
	[[ "${PRINT_INDENTS[1]}" == "TWO" ]]
}

@test "pop_print_indent: Should remove values from tail of PRINT_INDENTS array" {
	push_print_indent "ONE"
	push_print_indent "TWO"
	[[ ${#PRINT_INDENTS[@]} -eq  2    ]]
	[[ "${PRINT_INDENTS[0]}" == "ONE" ]]
	[[ "${PRINT_INDENTS[1]}" == "TWO" ]]

	pop_print_indent
	[[ ${#PRINT_INDENTS[@]} -eq  1    ]]
	[[ "${PRINT_INDENTS[0]}" == "ONE" ]]

	pop_print_indent
	[[ ${#PRINT_INDENTS[@]} -eq  0    ]]
}

@test "pop_print_indent: Should not generate error when PRINT_INDENTS array is empty" {
	[[ ${#PRINT_INDENTS[@]} -eq  0 ]]

	pop_print_indent
	[[ ${#PRINT_INDENTS[@]} -eq  0 ]]

	pop_print_indent
	[[ ${#PRINT_INDENTS[@]} -eq  0 ]]
}
