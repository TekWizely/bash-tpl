
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "STATEMENT_INDENT: Should exist and be set to '' on init" {
	[[ "${STATEMENT_INDENT-.}" == '' ]]
}

@test "STATEMENT_INDENTS: Should exist be empty on init" {
	[[ ${#STATEMENT_INDENTS[@]} -eq 0 ]]
}

@test "push_statement_indent: Should add values to tail of STATEMENT_INDENTS arary" {
	push_statement_indent "ONE"

	[[ ${#STATEMENT_INDENTS[@]} -eq  1    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]

	push_statement_indent "TWO"
	[[ ${#STATEMENT_INDENTS[@]} -eq  2    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]
	[[ "${STATEMENT_INDENTS[1]}" == "TWO" ]]
}

@test "peek_statement_indent: Should set STATEMENT_INDENT from tail of STATEMENT_INDENTS array" {
	push_statement_indent "ONE"
	[[ ${#STATEMENT_INDENTS[@]} -eq  1    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]

	peek_statement_indent
	[[ "${STATEMENT_INDENT}"     == "ONE" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  1    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]

	push_statement_indent "TWO"
	[[ ${#STATEMENT_INDENTS[@]} -eq  2    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]
	[[ "${STATEMENT_INDENTS[1]}" == "TWO" ]]

	peek_statement_indent
	[[ "${STATEMENT_INDENT}"     == "TWO" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  2    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]
	[[ "${STATEMENT_INDENTS[1]}" == "TWO" ]]
}

@test "peek_statement_indent: Should set STATEMENT_INDENT to '' when STATEMENT_INDENTS array is empty" {
	[[ ${#STATEMENT_INDENTS[@]} -eq  0    ]]

	STATEMENT_INDENT="BATS"
	peek_statement_indent
	[[ "${STATEMENT_INDENT}"     == "" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  0 ]]
}

@test "pop_statement_indent: Should remove values from tail of STATEMENT_INDENTS array" {
	push_statement_indent "ONE"
	push_statement_indent "TWO"
	[[ ${#STATEMENT_INDENTS[@]} -eq  2    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]
	[[ "${STATEMENT_INDENTS[1]}" == "TWO" ]]

	pop_statement_indent
	[[ ${#STATEMENT_INDENTS[@]} -eq  1    ]]
	[[ "${STATEMENT_INDENTS[0]}" == "ONE" ]]

	pop_statement_indent
	[[ ${#STATEMENT_INDENTS[@]} -eq  0    ]]
}

@test "pop_statement_indent: Should not generate error when STATEMENT_INDENTS array is empty" {
	[[ ${#STATEMENT_INDENTS[@]} -eq  0 ]]

	pop_statement_indent
	[[ ${#STATEMENT_INDENTS[@]} -eq  0 ]]

	pop_statement_indent
	[[ ${#STATEMENT_INDENTS[@]} -eq  0 ]]
}
