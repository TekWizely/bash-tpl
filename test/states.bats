
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "STATE: Should exist and be set to 'DEFAULT' on init" {
	[[ "${STATE}" == "DEFAULT" ]]
}

@test "STATES: Should exist be empty on init" {
	[[ ${#STATES[@]} -eq 0 ]]
}

@test "push_state: Should add values to tail of STATES arary" {
	push_state "ONE"

	[[ ${#STATES[@]} -eq  1    ]]
	[[ "${STATES[0]}" == "ONE" ]]

	push_state "TWO"
	[[ ${#STATES[@]} -eq  2    ]]
	[[ "${STATES[0]}" == "ONE" ]]
	[[ "${STATES[1]}" == "TWO" ]]
}

@test "peek_state: Should return values from tail of STATES array" {
	push_state "ONE"
	[[ ${#STATES[@]} -eq  1    ]]
	[[ "${STATES[0]}" == "ONE" ]]

	run peek_state
	[[ "${output}"    == "ONE" ]]
	[[ ${#STATES[@]} -eq  1    ]]
	[[ "${STATES[0]}" == "ONE" ]]

	push_state "TWO"
	[[ ${#STATES[@]} -eq  2    ]]
	[[ "${STATES[0]}" == "ONE" ]]
	[[ "${STATES[1]}" == "TWO" ]]

	run peek_state
	[[ ${#STATES[@]} -eq  2    ]]
	[[ "${STATES[0]}" == "ONE" ]]
	[[ "${STATES[1]}" == "TWO" ]]
}

@test "peek_state: Should return 'DEFAULT' when STATES array is empty" {
	[[ ${#STATES[@]} -eq  0    ]]

	run peek_state
	[[ "${output}"    == "DEFAULT" ]]
	[[ ${#STATES[@]} -eq  0        ]]
}

@test "pop_state: Should remove values from tail of STATES array" {
	push_state "ONE"
	push_state "TWO"
	[[ ${#STATES[@]} -eq  2    ]]
	[[ "${STATES[0]}" == "ONE" ]]
	[[ "${STATES[1]}" == "TWO" ]]

	pop_state
	[[ ${#STATES[@]} -eq  1    ]]
	[[ "${STATES[0]}" == "ONE" ]]

	pop_state
	[[ ${#STATES[@]} -eq  0    ]]
}

@test "pop_state: Should not generate error when STATES array is empty" {
	[[ ${#STATES[@]} -eq  0 ]]

	pop_state
	[[ ${#STATES[@]} -eq  0 ]]

	pop_state
	[[ ${#STATES[@]} -eq  0 ]]
}
