
setup() {
	bats_require_minimum_version 1.7.0
	# shellcheck source=../bash-tpl
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "reset_delims: should set default delims" {

	reset_delims

	[[ "${TAG_START_DELIM1}"           == '<' ]]
	[[ "${TAG_START_DELIM2}"           == '%' ]]
	[[ "${TAG_STOP_DELIM1}"            == '%' ]]
	[[ "${TAG_STOP_DELIM2}"            == '>' ]]
	[[ "${TAG_STMT_DELIM}"             == '%' ]]
	[[ "${TAG_FMT_START_DELIM}"        == '|' ]]
	[[ "${TAG_FMT_STOP_DELIM}"         == '|' ]]
	[[ "${STMT_DELIM}"                 == '%' ]]
	[[ "${STMT_BLOCK_DELIM_UNDEFINED}" == '1' ]]
	[[ "${STMT_BLOCK_START_DELIM}"     == ''  ]]
	[[ "${STMT_BLOCK_STOP_DELIM}"      == ''  ]]
	[[ "${TEXT_DELIM_UNDEFINED}"       == '1' ]]
	[[ "${TEXT_DELIM}"                 == ''  ]]
	[[ "${DIRECTIVE_DELIM}"            == '.' ]]
	[[ "${COMMENT_DELIM_UNDEFINED}"    == '1' ]]
	[[ "${COMMENT_DELIM}"              == ''  ]]
}

@test "parse_tag_delims: Should error on invalid input" {
	# Empty
	#
	run parse_tag_delims '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag delimiter values for BATS: ''" ]]

	# All Spaces
	#
	run parse_tag_delims '     ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag delimiter values for BATS: '     '" ]]

	# No middle-space
	#
	run parse_tag_delims '{{}}' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag delimiter values for BATS: '{{}}'" ]]
}

@test "parse_tag_delims: Should process valid input" {

	[[ -z "${TAG_START_DELIM1}" ]]
	[[ -z "${TAG_START_DELIM2}" ]]
	[[ -z "${TAG_STOP_DELIM1}"  ]]
	[[ -z "${TAG_STOP_DELIM2}"  ]]

	parse_tag_delims 'ab cd'

	[[ "${TAG_START_DELIM1}" == 'a' ]]
	[[ "${TAG_START_DELIM2}" == 'b' ]]
	[[ "${TAG_STOP_DELIM1}"  == 'c' ]]
	[[ "${TAG_STOP_DELIM2}"  == 'd' ]]

	parse_tag_delims '{{ }}'

	[[ "${TAG_START_DELIM1}" == '{' ]]
	[[ "${TAG_START_DELIM2}" == '{' ]]
	[[ "${TAG_STOP_DELIM1}"  == '}' ]]
	[[ "${TAG_STOP_DELIM2}"  == '}' ]]
}

@test "parse_tag_stmt_delim: Should error on invalid input" {
	# Empty
	#
	run parse_tag_stmt_delim '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag stmt delimiter value for BATS: ''" ]]

	# Space
	#
	run parse_tag_stmt_delim ' ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag stmt delimiter value for BATS: ' '" ]]

	# Too long
	#
	run parse_tag_stmt_delim '%%' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag stmt delimiter value for BATS: '%%'" ]]
}

@test "parse_tag_stmt_delim: Should process valid input" {

	[[ -z "${TAG_STMT_DELIM}" ]]

	parse_tag_stmt_delim '%'

	[[ "${TAG_STMT_DELIM}" == '%' ]]

	parse_tag_stmt_delim '$'

	[[ "${TAG_STMT_DELIM}" == '$' ]]
}

@test "parse_tag_fmt_delims: Should error on invalid input" {
	# Empty
	#
	run parse_tag_fmt_delims '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag fmt delimiter values for BATS: ''" ]]

	# All Spaces
	#
	run parse_tag_fmt_delims '     ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag fmt delimiter values for BATS: '     '" ]]

	# No middle-space
	#
	run parse_tag_fmt_delims '||' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing tag fmt delimiter values for BATS: '||'" ]]
}

@test "parse_tag_fmt_delims: Should process valid input" {

	[[ -z "${TAG_FMT_START_DELIM}" ]]
	[[ -z "${TAG_FMT_STOP_DELIM}"  ]]

	parse_tag_fmt_delims '| |'

	[[ "${TAG_FMT_START_DELIM}" == '|' ]]
	[[ "${TAG_FMT_STOP_DELIM}"  == '|' ]]

	parse_tag_fmt_delims '[ ]'

	[[ "${TAG_FMT_START_DELIM}" == '[' ]]
	[[ "${TAG_FMT_STOP_DELIM}"  == ']' ]]
}

@test "parse_stmt_delim: Should error on invalid input" {
	# Empty
	#
	run parse_stmt_delim '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt delimiter value for BATS: ''" ]]

	# Space
	#
	run parse_stmt_delim ' ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt delimiter value for BATS: ' '" ]]
}

@test "parse_stmt_delim: Should process valid input" {

	[[ -z "${STMT_DELIM}" ]]

	parse_stmt_delim '%'

	[[ "${STMT_DELIM}" == '%' ]]

	parse_stmt_delim '-->'

	[[ "${STMT_DELIM}" == '-->' ]]
}

@test "parse_stmt_block_delims: Should error on invalid input" {
	# Empty
	#
	run parse_stmt_block_delims '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt-block delimiter values for BATS: ''" ]]

	# All Spaces
	#
	run parse_stmt_block_delims '     ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt-block delimiter values for BATS: '     '" ]]

	# No middle-space
	#
	run parse_stmt_block_delims '<%%>' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing stmt-block delimiter values for BATS: '<%%>'" ]]
}

@test "parse_stmt_block_delims: Should process valid input" {

	[[ -z "${STMT_BLOCK_START_DELIM}"     ]]
	[[ -z "${STMT_BLOCK_STOP_DELIM}"      ]]
	[[ -z "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	STMT_BLOCK_DELIM_UNDEFINED=1
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]
	parse_stmt_block_delims 'ab cd'

	[[    "${STMT_BLOCK_START_DELIM}" == 'ab' ]]
	[[    "${STMT_BLOCK_STOP_DELIM}"  == 'cd' ]]
	[[ -z "${STMT_BLOCK_DELIM_UNDEFINED}"     ]]

	STMT_BLOCK_DELIM_UNDEFINED=1
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]
	parse_stmt_block_delims '<% %>'

	[[    "${STMT_BLOCK_START_DELIM}" == '<%' ]]
	[[    "${STMT_BLOCK_STOP_DELIM}"  == '%>' ]]
	[[ -z "${STMT_BLOCK_DELIM_UNDEFINED}"     ]]
}

@test "parse_directive_delim: Should error on invalid input" {
	# Empty
	#
	run parse_directive_delim '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing directive delimiter value for BATS: ''" ]]

	# Space
	#
	run parse_directive_delim ' ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing directive delimiter value for BATS: ' '" ]]
}

@test "parse_text_delim: Should error on invalid input" {
	# Empty
	#
	run parse_text_delim '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing text delimiter value for BATS: ''" ]]

	# Space
	#
	run parse_text_delim ' ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing text delimiter value for BATS: ' '" ]]
}

@test "parse_text_delim: Should process valid input" {

	[[ -z "${TEXT_DELIM}" ]]
	[[ -z "${TEXT_DELIM_UNDEFINED}" ]]

	TEXT_DELIM_UNDEFINED=1
	[[ -n "${TEXT_DELIM_UNDEFINED}" ]]
	parse_text_delim '% '

	[[    "${TEXT_DELIM}" == '% '    ]]
	[[ -z "${TEXT_DELIM_UNDEFINED}" ]]

	TEXT_DELIM_UNDEFINED=1
	[[ -n "${TEXT_DELIM_UNDEFINED}" ]]
	parse_text_delim '>>'

	[[    "${TEXT_DELIM}" == '>>'   ]]
	[[ -z "${TEXT_DELIM_UNDEFINED}" ]]
}

@test "parse_directive_delim: Should process valid input" {

	[[ -z "${DIRECTIVE_DELIM}" ]]

	parse_directive_delim '.'

	[[ "${DIRECTIVE_DELIM}" == '.' ]]

	parse_directive_delim '-->'

	[[ "${DIRECTIVE_DELIM}" == '-->' ]]
}

@test "parse_comment_delim: Should error on invalid input" {
	# Empty
	#
	run parse_comment_delim '' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing comment delimiter value for BATS: ''" ]]

	# Space
	#
	run parse_comment_delim ' ' 'BATS'
	[[ $status -eq 1 ]]
	[[ "$output" == "Error: Invalid or missing comment delimiter value for BATS: ' '" ]]
}

@test "parse_comment_delim: Should process valid input" {

	[[ -z "${COMMENT_DELIM}" ]]
	[[ -z "${COMMENT_DELIM_UNDEFINED}" ]]

	COMMENT_DELIM_UNDEFINED=1
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]
	parse_comment_delim '#'

	[[    "${COMMENT_DELIM}" == '#'    ]]
	[[ -z "${COMMENT_DELIM_UNDEFINED}" ]]

	COMMENT_DELIM_UNDEFINED=1
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]
	parse_comment_delim '//'

	[[    "${COMMENT_DELIM}" == '//'   ]]
	[[ -z "${COMMENT_DELIM_UNDEFINED}" ]]
}
