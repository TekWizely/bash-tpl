
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "BASH_TPL_TAG_DELIMS: Should do nothing when unset or empty" {

	[[ -z "${TAG_START_DELIM1}" ]]
	[[ -z "${TAG_START_DELIM2}" ]]
	[[ -z "${TAG_STOP_DELIM1}"  ]]
	[[ -z "${TAG_STOP_DELIM2}"  ]]

	unset BASH_TPL_TAG_DELIMS
	parse_env_delims

	[[ -z "${TAG_START_DELIM1}" ]]
	[[ -z "${TAG_START_DELIM2}" ]]
	[[ -z "${TAG_STOP_DELIM1}"  ]]
	[[ -z "${TAG_STOP_DELIM2}"  ]]

	BASH_TPL_TAG_DELIMS=''
	parse_env_delims

	[[ -z "${TAG_START_DELIM1}" ]]
	[[ -z "${TAG_START_DELIM2}" ]]
	[[ -z "${TAG_STOP_DELIM1}"  ]]
	[[ -z "${TAG_STOP_DELIM2}"  ]]
}

@test "BASH_TPL_TAG_DELIMS: Should error on invalid input" {
	# No middle-space
	#
	BASH_TPL_TAG_DELIMS='{{}}'
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag delimiter values for BASH_TPL_TAG_DELIMS: '{{}}'" ]]

	# All Spaces
	#
	BASH_TPL_TAG_DELIMS='     '
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag delimiter values for BASH_TPL_TAG_DELIMS: '     '" ]]
}

@test "BASH_TPL_TAG_DELIMS: Should process valid input" {

	[[ -z "${TAG_START_DELIM1}" ]]
	[[ -z "${TAG_START_DELIM2}" ]]
	[[ -z "${TAG_STOP_DELIM1}"  ]]
	[[ -z "${TAG_STOP_DELIM2}"  ]]

	BASH_TPL_TAG_DELIMS='ab cd'
	parse_env_delims

	[[ "${TAG_START_DELIM1}" == 'a' ]]
	[[ "${TAG_START_DELIM2}" == 'b' ]]
	[[ "${TAG_STOP_DELIM1}"  == 'c' ]]
	[[ "${TAG_STOP_DELIM2}"  == 'd' ]]

	BASH_TPL_TAG_DELIMS='{{ }}'
	parse_env_delims

	[[ "${TAG_START_DELIM1}" == '{' ]]
	[[ "${TAG_START_DELIM2}" == '{' ]]
	[[ "${TAG_STOP_DELIM1}"  == '}' ]]
	[[ "${TAG_STOP_DELIM2}"  == '}' ]]
}

@test "BASH_TPL_TAG_STMT_DELIM: Should do nothing when unset or empty" {

	[[ -z "${TAG_STMT_DELIM}" ]]

	unset BASH_TPL_TAG_STMT_DELIM
	parse_env_delims

	[[ -z "${TAG_STMT_DELIM}" ]]

	BASH_TPL_TAG_STMT_DELIM=''
	parse_env_delims

	[[ -z "${TAG_STMT_DELIM}" ]]
}

@test "BASH_TPL_TAG_STMT_DELIM: Should error on invalid input" {
	# Too long
	#
	BASH_TPL_TAG_STMT_DELIM='%%'
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag stmt delimiter value for BASH_TPL_TAG_STMT_DELIM: '%%'" ]]

	# Space
	#
	BASH_TPL_TAG_STMT_DELIM=' '
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag stmt delimiter value for BASH_TPL_TAG_STMT_DELIM: ' '" ]]
}

@test "BASH_TPL_TAG_STMT_DELIM: Should process valid input" {

	[[ -z "${TAG_STMT_DELIM}" ]]

	BASH_TPL_TAG_STMT_DELIM='%'
	parse_env_delims

	[[ "${TAG_STMT_DELIM}" == '%' ]]

	BASH_TPL_TAG_STMT_DELIM='$'
	parse_env_delims

	[[ "${TAG_STMT_DELIM}" == '$' ]]
}

@test "BASH_TPL_STMT_DELIM: Should do nothing when unset or empty" {

	[[ -z "${STMT_DELIM}" ]]

	unset BASH_TPL_STMT_DELIM
	parse_env_delims

	[[ -z "${STMT_DELIM}" ]]

	BASH_TPL_STMT_DELIM=''
	parse_env_delims

	[[ -z "${STMT_DELIM}" ]]
}

@test "BASH_TPL_STMT_DELIM: Should error on invalid input" {
	# Space
	#
	BASH_TPL_STMT_DELIM=' '
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt delimiter value for BASH_TPL_STMT_DELIM: ' '" ]]
}

@test "BASH_TPL_STMT_DELIM: Should process valid input" {

	[[ -z "${STMT_DELIM}" ]]

	BASH_TPL_STMT_DELIM='%'
	parse_env_delims

	[[ "${STMT_DELIM}" == '%' ]]

	BASH_TPL_STMT_DELIM='-->'
	parse_env_delims

	[[ "${STMT_DELIM}" == '-->' ]]
}

@test "BASH_TPL_STMT_BLOCK_DELIMS: Should do nothing when unset or empty" {

	[[ -z "${STMT_BLOCK_START_DELIM}"     ]]
	[[ -z "${STMT_BLOCK_STOP_DELIM}"      ]]
	[[ -z "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	STMT_BLOCK_DELIM_UNDEFINED=1
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	unset BASH_TPL_STMT_BLOCK_DELIMS
	parse_env_delims

	[[ -z "${STMT_BLOCK_START_DELIM}"     ]]
	[[ -z "${STMT_BLOCK_STOP_DELIM}"      ]]
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	BASH_TPL_STMT_BLOCK_DELIMS=''
	parse_env_delims

	[[ -z "${STMT_BLOCK_START_DELIM}"     ]]
	[[ -z "${STMT_BLOCK_STOP_DELIM}"      ]]
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]
}

@test "BASH_TPL_STMT_BLOCK_DELIMS: Should error on invalid input" {
	# All Spaces
	#
	BASH_TPL_STMT_BLOCK_DELIMS='     '
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt-block delimiter values for BASH_TPL_STMT_BLOCK_DELIMS: '     '" ]]

	# No middle-space
	#
	BASH_TPL_STMT_BLOCK_DELIMS='<%%>'
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt-block delimiter values for BASH_TPL_STMT_BLOCK_DELIMS: '<%%>'" ]]
}

@test "BASH_TPL_STMT_BLOCK_DELIMS: Should process valid input" {

	[[ -z "${STMT_BLOCK_START_DELIM}"     ]]
	[[ -z "${STMT_BLOCK_STOP_DELIM}"      ]]
	[[ -z "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	STMT_BLOCK_DELIM_UNDEFINED=1
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	BASH_TPL_STMT_BLOCK_DELIMS='ab cd'
	parse_env_delims

	[[    "${STMT_BLOCK_START_DELIM}" == 'ab' ]]
	[[    "${STMT_BLOCK_STOP_DELIM}"  == 'cd' ]]
	[[ -z "${STMT_BLOCK_DELIM_UNDEFINED}"     ]]

	STMT_BLOCK_DELIM_UNDEFINED=1
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	BASH_TPL_STMT_BLOCK_DELIMS='<% %>'
	parse_env_delims

	[[    "${STMT_BLOCK_START_DELIM}" == '<%' ]]
	[[    "${STMT_BLOCK_STOP_DELIM}"  == '%>' ]]
	[[ -z "${STMT_BLOCK_DELIM_UNDEFINED}"     ]]
}

@test "BASH_TPL_TEXT_DELIM: Should do nothing when unset or empty" {

	[[ -z "${TEXT_DELIM}" ]]
	[[ -z "${TEXT_DELIM_UNDEFINED}" ]]

	TEXT_DELIM_UNDEFINED=1
	[[ -n "${TEXT_DELIM_UNDEFINED}" ]]

	unset BASH_TPL_TEXT_DELIM
	parse_env_delims

	[[ -z "${TEXT_DELIM}" ]]
	[[ -n "${TEXT_DELIM_UNDEFINED}" ]]

	BASH_TPL_TEXT_DELIM=''
	parse_env_delims

	[[ -z "${TEXT_DELIM}" ]]
	[[ -n "${TEXT_DELIM_UNDEFINED}" ]]
}

@test "BASH_TPL_TEXT_DELIM: Should error on invalid input" {
	# Space
	#
	BASH_TPL_TEXT_DELIM=' '
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing text delimiter value for BASH_TPL_TEXT_DELIM: ' '" ]]
}

@test "BASH_TPL_TEXT_DELIM: Should process valid input" {

	[[ -z "${TEXT_DELIM}" ]]
	[[ -z "${TEXT_DELIM_UNDEFINED}" ]]

	TEXT_DELIM_UNDEFINED=1
	[[ -n "${TEXT_DELIM_UNDEFINED}" ]]

	BASH_TPL_TEXT_DELIM='% '
	parse_env_delims

	[[    "${TEXT_DELIM}" == '% '    ]]
	[[ -z "${TEXT_DELIM_UNDEFINED}" ]]

	TEXT_DELIM_UNDEFINED=1
	[[ -n "${TEXT_DELIM_UNDEFINED}" ]]

	BASH_TPL_TEXT_DELIM='>>'
	parse_env_delims

	[[    "${TEXT_DELIM}" == '>>'   ]]
	[[ -z "${TEXT_DELIM_UNDEFINED}" ]]
}

@test "BASH_TPL_DIR_DELIM: Should do nothing when unset or empty" {

	[[ -z "${DIRECTIVE_DELIM}" ]]

	unset BASH_TPL_DIR_DELIM
	parse_env_delims

	[[ -z "${DIRECTIVE_DELIM}" ]]

	BASH_TPL_DIR_DELIM=''
	parse_env_delims

	[[ -z "${DIRECTIVE_DELIM}" ]]
}

@test "BASH_TPL_DIR_DELIM: Should error on invalid input" {
	# Space
	#
	BASH_TPL_DIR_DELIM=' '
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing directive delimiter value for BASH_TPL_DIR_DELIM: ' '" ]]
}

@test "BASH_TPL_DIR_DELIM: Should process valid input" {

	[[ -z "${DIRECTIVE_DELIM}" ]]

	BASH_TPL_DIR_DELIM='.'
	parse_env_delims

	[[ "${DIRECTIVE_DELIM}" == '.' ]]

	BASH_TPL_DIR_DELIM='-->'
	parse_env_delims

	[[ "${DIRECTIVE_DELIM}" == '-->' ]]
}

@test "BASH_TPL_CMT_DELIM: Should do nothing when unset or empty" {

	[[ -z "${COMMENT_DELIM}" ]]
	[[ -z "${COMMENT_DELIM_UNDEFINED}" ]]

	COMMENT_DELIM_UNDEFINED=1
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]

	unset BASH_TPL_CMT_DELIM
	parse_env_delims

	[[ -z "${COMMENT_DELIM}" ]]
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]

	BASH_TPL_CMT_DELIM=''
	parse_env_delims

	[[ -z "${COMMENT_DELIM}" ]]
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]
}

@test "BASH_TPL_CMT_DELIM: Should error on invalid input" {
	# Space
	#
	BASH_TPL_CMT_DELIM=' '
	run parse_env_delims
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing comment delimiter value for BASH_TPL_CMT_DELIM: ' '" ]]
}

@test "BASH_TPL_CMT_DELIM: Should process valid input" {

	[[ -z "${COMMENT_DELIM}" ]]
	[[ -z "${COMMENT_DELIM_UNDEFINED}" ]]

	COMMENT_DELIM_UNDEFINED=1
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]

	BASH_TPL_CMT_DELIM='#'
	parse_env_delims

	[[    "${COMMENT_DELIM}" == '#'    ]]
	[[ -z "${COMMENT_DELIM_UNDEFINED}" ]]

	COMMENT_DELIM_UNDEFINED=1
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]

	BASH_TPL_CMT_DELIM='//'
	parse_env_delims

	[[    "${COMMENT_DELIM}" == '//'   ]]
	[[ -z "${COMMENT_DELIM_UNDEFINED}" ]]
}
