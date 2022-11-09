
setup() {
	# shellcheck source=../bash-tpl
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "STATEMENT_INDENT: Should exist and be set to '' on init" {
	[[ "${STATEMENT_INDENT-.}" == "" ]]
}

@test "STATEMENT_INDENTS: Should exist and be empty on init" {
	[[ ${#STATEMENT_INDENTS[@]} -eq 0 ]]
}

@test "push_statement_indent: Should add current STATEMENT_INDENT to tail of STATEMENT_INDENTS array, set STATEMENT_INDENT to new value" {
	push_statement_indent "ONE"
	[[ ${STATEMENT_INDENT}       == "ONE" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  1    ]]
	[[ "${STATEMENT_INDENTS[0]}" == ""    ]]

	push_statement_indent "TWO"
	[[ ${STATEMENT_INDENT}       == "TWO" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  2    ]]
	[[ "${STATEMENT_INDENTS[0]}" == ""    ]]
	[[ "${STATEMENT_INDENTS[1]}" == "ONE" ]]
}

@test "pop_statement_indent: Should remove tail of STATEMENT_INDENTS array, setting STATEMENT_INDENT to removed value" {
	push_statement_indent "ONE"
	push_statement_indent "TWO"
	[[ ${STATEMENT_INDENT}       == "TWO" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  2    ]]
	[[ "${STATEMENT_INDENTS[0]}" == ""    ]]
	[[ "${STATEMENT_INDENTS[1]}" == "ONE" ]]

	pop_statement_indent
	[[ ${STATEMENT_INDENT}       == "ONE" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  1    ]]
	[[ "${STATEMENT_INDENTS[0]}" == ""    ]]

	pop_statement_indent
	[[ ${STATEMENT_INDENT}       == ""    ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  0    ]]
}

@test "pop_statement_indent: Should set STATEMENT_INDENT to '', should not generate error when STATEMENT_INDENTS array is empty" {
	[[ ${STATEMENT_INDENT}       == "" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  0 ]]

	STATEMENT_INDENT="."
	pop_statement_indent
	[[ ${STATEMENT_INDENT}       == "" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  0 ]]

	STATEMENT_INDENT="."
	pop_statement_indent
	[[ ${STATEMENT_INDENT}       == "" ]]
	[[ ${#STATEMENT_INDENTS[@]} -eq  0 ]]
}
