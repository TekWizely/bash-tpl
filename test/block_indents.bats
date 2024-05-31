
setup() {
	bats_require_minimum_version 1.7.0
	# shellcheck source=../bash-tpl
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "BLOCK_INDENT: Should exist and be set to '' on init" {
	[[ "${BLOCK_INDENT-.}" == "" ]]
}

@test "BLOCK_INDENTS: Should exist and be empty on init" {
	[[ ${#BLOCK_INDENTS[@]} -eq 0 ]]
}

@test "push_block_indent: Should add current BLOCK_INDENT to tail of BLOCK_INDENTS array, set BLOCK_INDENT to new value" {
	push_block_indent "ONE"
	[[ ${BLOCK_INDENT}       == "ONE" ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  1    ]]
	[[ "${BLOCK_INDENTS[0]}" == ""    ]]

	push_block_indent "TWO"
	[[ ${BLOCK_INDENT}       == "TWO" ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  2    ]]
	[[ "${BLOCK_INDENTS[0]}" == ""    ]]
	[[ "${BLOCK_INDENTS[1]}" == "ONE" ]]
}

@test "pop_block_indent: Should remove tail of BLOCK_INDENTS array, setting BLOCK_INDENT to removed value" {
	push_block_indent "ONE"
	push_block_indent "TWO"
	[[ ${BLOCK_INDENT}       == "TWO" ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  2    ]]
	[[ "${BLOCK_INDENTS[0]}" == ""    ]]
	[[ "${BLOCK_INDENTS[1]}" == "ONE" ]]

	pop_block_indent
	[[ ${BLOCK_INDENT}       == "ONE" ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  1    ]]
	[[ "${BLOCK_INDENTS[0]}" == ""    ]]

	pop_block_indent
	[[ ${BLOCK_INDENT}       == ""    ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  0    ]]
}

@test "pop_block_indent: Should set BLOCK_INDENT to '', should not generate error when BLOCK_INDENTS array is empty" {
	[[ ${BLOCK_INDENT}       == "" ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  0 ]]

	BLOCK_INDENT="."
	pop_block_indent
	[[ ${BLOCK_INDENT}       == "" ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  0 ]]

	BLOCK_INDENT="."
	pop_block_indent
	[[ ${BLOCK_INDENT}       == "" ]]
	[[ ${#BLOCK_INDENTS[@]} -eq  0 ]]
}
