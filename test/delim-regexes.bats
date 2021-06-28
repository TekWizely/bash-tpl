
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "delim regexes should be defined" {
	[[ -n "${TAG_DELIM_REGEX}"        ]]
	[[ -n "${TAG_STMT_DELIM_REGEX}"   ]]
	[[ -n "${STMT_DELIM_REGEX}"       ]]
	[[ -n "${STMT_BLOCK_DELIM_REGEX}" ]]
}

@test "TAG_DELIM_REGEX: invalid data should fail" {
	[[ ! ''        =~ $TAG_DELIM_REGEX ]]
	[[ ! ' '       =~ $TAG_DELIM_REGEX ]]
	[[ ! 'a b'     =~ $TAG_DELIM_REGEX ]]
	[[ ! 'a bc'    =~ $TAG_DELIM_REGEX ]]
	[[ ! 'a bcd'   =~ $TAG_DELIM_REGEX ]]
	[[ ! 'ab c'    =~ $TAG_DELIM_REGEX ]]
	[[ ! 'ab cde'  =~ $TAG_DELIM_REGEX ]]
	[[ ! 'abc def' =~ $TAG_DELIM_REGEX ]]
	[[ ! 'abcd'    =~ $TAG_DELIM_REGEX ]]
	[[ ! ' ab cd'  =~ $TAG_DELIM_REGEX ]]
	[[ ! 'ab cd '  =~ $TAG_DELIM_REGEX ]]
	[[ ! ' ab cd ' =~ $TAG_DELIM_REGEX ]]
	[[ ! 'ab  cd'  =~ $TAG_DELIM_REGEX ]]
}

@test "TAG_DELIM_REGEX: valid data should pass" {
	[[ 'ab cd' =~ $TAG_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'a' ]]
	[[ "${BASH_REMATCH[2]}" == 'b' ]]
	[[ "${BASH_REMATCH[3]}" == 'c' ]]
	[[ "${BASH_REMATCH[4]}" == 'd' ]]

	[[ '{{ }}' =~ $TAG_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '{' ]]
	[[ "${BASH_REMATCH[2]}" == '{' ]]
	[[ "${BASH_REMATCH[3]}" == '}' ]]
	[[ "${BASH_REMATCH[4]}" == '}' ]]

	[[ '<% %>' =~ $TAG_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '<' ]]
	[[ "${BASH_REMATCH[2]}" == '%' ]]
	[[ "${BASH_REMATCH[3]}" == '%' ]]
	[[ "${BASH_REMATCH[4]}" == '>' ]]

	[[ '.. ..' =~ $TAG_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '.' ]]
	[[ "${BASH_REMATCH[2]}" == '.' ]]
	[[ "${BASH_REMATCH[3]}" == '.' ]]
	[[ "${BASH_REMATCH[4]}" == '.' ]]
}

@test "TAG_STMT_DELIM_REGEX: invalid data should fail" {
	[[ ! ''    =~ $TAG_STMT_DELIM_REGEX ]]
	[[ ! ' '   =~ $TAG_STMT_DELIM_REGEX ]]
	[[ ! ' a'  =~ $TAG_STMT_DELIM_REGEX ]]
	[[ ! 'a '  =~ $TAG_STMT_DELIM_REGEX ]]
	[[ ! 'ab'  =~ $TAG_STMT_DELIM_REGEX ]]
	[[ ! 'a b' =~ $TAG_STMT_DELIM_REGEX ]]
	[[ ! 'abc' =~ $TAG_STMT_DELIM_REGEX ]]
}

@test "TAG_STMT_DELIM_REGEX: valid data should pass" {
	[[ 'a' =~ $TAG_STMT_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'a'  ]]

	[[ '%' =~ $TAG_STMT_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '%'  ]]

	[[ '$' =~ $TAG_STMT_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '$'  ]]

	[[ '.' =~ $TAG_STMT_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '.'  ]]
}

@test "STMT_DELIM_REGEX: invalid data should fail" {
	[[ ! ''    =~ $STMT_DELIM_REGEX ]]
	[[ ! ' '   =~ $STMT_DELIM_REGEX ]]
	[[ ! '  '  =~ $STMT_DELIM_REGEX ]]
	[[ ! ' a'  =~ $STMT_DELIM_REGEX ]]
	[[ ! 'a '  =~ $STMT_DELIM_REGEX ]]
	[[ ! 'ab ' =~ $STMT_DELIM_REGEX ]]
	[[ ! 'a b' =~ $STMT_DELIM_REGEX ]]
	[[ ! ' ab' =~ $STMT_DELIM_REGEX ]]
}

@test "STMT_DELIM_REGEX: valid data should pass" {
	[[ 'a' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == 'a' ]]

	[[ 'ab' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == 'ab' ]]

	[[ 'abc' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == 'abc' ]]

	[[ '%' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == '%' ]]

	[[ '%%' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == '%%' ]]

	[[ '%%%' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == '%%%' ]]

	[[ '.' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == '.' ]]

	[[ '.$.' =~ $STMT_DELIM_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == '.$.' ]]
}

@test "STMT_BLOCK_DELIM_REGEX: invalid data should fail" {
	[[ ! ''        =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ ! ' '       =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ ! 'abcd'    =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ ! ' ab cd'  =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ ! 'ab cd '  =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ ! ' ab cd ' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ ! 'ab  cd'  =~ $STMT_BLOCK_DELIM_REGEX ]]
}

@test "STMT_BLOCK_DELIM_REGEX: valid data should pass" {
	[[ 'a b' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'a'      ]]
	[[ "${BASH_REMATCH[2]}" == 'b'      ]]

	[[ 'ab cd' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'ab'       ]]
	[[ "${BASH_REMATCH[2]}" == 'cd'       ]]

	[[ 'abc def' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'abc'        ]]
	[[ "${BASH_REMATCH[2]}" == 'def'        ]]

	[[ '% %' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '%'      ]]
	[[ "${BASH_REMATCH[2]}" == '%'      ]]

	[[ '<% %>' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '<%'       ]]
	[[ "${BASH_REMATCH[2]}" == '%>'       ]]

	[[ '. .' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '.'      ]]
	[[ "${BASH_REMATCH[2]}" == '.'      ]]

	[[ '.. ..' =~ $STMT_BLOCK_DELIM_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '..'       ]]
	[[ "${BASH_REMATCH[2]}" == '..'       ]]
}
