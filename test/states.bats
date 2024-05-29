
setup() {
	bats_require_minimum_version 1.7.0
	# shellcheck source=../bash-tpl
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "STATE: Should exist and be set to 'DEFAULT' on init" {
	[[ "${STATE-.}" == "DEFAULT" ]]
}

@test "STATES: Should exist and be empty on init" {
	[[ ${#STATES[@]} -eq 0 ]]
}

@test "push_state:  Should add current STATE to tail of STATES array, set STATE to new value" {
	push_state "ONE"
	[[ ${STATE}       == "ONE"     ]]
	[[ ${#STATES[@]} -eq  1        ]]
	[[ "${STATES[0]}" == "DEFAULT" ]]

	push_state "TWO"
	[[ ${STATE}       == "TWO"     ]]
	[[ ${#STATES[@]} -eq  2        ]]
	[[ "${STATES[0]}" == "DEFAULT" ]]
	[[ "${STATES[1]}" == "ONE"     ]]
}

@test "pop_state: Should remove tail of STATES array, setting STATE to removed value" {
	push_state "ONE"
	push_state "TWO"
	[[ ${STATE}       == "TWO"     ]]
	[[ ${#STATES[@]} -eq  2        ]]
	[[ "${STATES[0]}" == "DEFAULT" ]]
	[[ "${STATES[1]}" == "ONE"     ]]

	pop_state
	[[ ${STATE}       == "ONE"     ]]
	[[ ${#STATES[@]} -eq  1        ]]
	[[ "${STATES[0]}" == "DEFAULT" ]]

	pop_state
	[[ ${STATE}       == "DEFAULT" ]]
	[[ ${#STATES[@]} -eq  0        ]]
}

@test "pop_state: Should set STATE to 'DEFAULT', should not generate error when STATES array is empty" {
	[[ ${STATE}       == "DEFAULT" ]]
	[[ ${#STATES[@]} -eq  0        ]]

	STATE="."
	pop_state
	[[ ${STATE}       == "DEFAULT" ]]
	[[ ${#STATES[@]} -eq  0        ]]

	STATE="."
	pop_state
	[[ ${STATE}       == "DEFAULT" ]]
	[[ ${#STATES[@]} -eq  0        ]]
}
