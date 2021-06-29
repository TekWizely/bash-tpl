
setup() {
	source "${BATS_TEST_DIRNAME}/../bash-tpl"
}

@test "reset_template_regexes: should default stmt-block delims to stmt-delim if not set" {

	reset_delims

	# Creates valid stmt delim, empty stmt-block delims
	# Sets default flag for stmt-block delims
	#
	[[ -n "${STMT_DELIM}"                 ]]
	[[ -z "${STMT_BLOCK_START_DELIM}"     ]]
	[[ -z "${STMT_BLOCK_STOP_DELIM}"      ]]
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]

	reset_template_regexes

	# Defaults stmt-block delims to stmt delim
	# Leaves default flag set for stmt-block delims
	#
	[[    "${STMT_BLOCK_START_DELIM}" == "${STMT_DELIM}" ]]
	[[    "${STMT_BLOCK_STOP_DELIM}"  == "${STMT_DELIM}" ]]
	[[ -n "${STMT_BLOCK_DELIM_UNDEFINED}"                ]]
}

@test "reset_template_regexes: should default comment delim to stmt-delim + '#' if not set" {

	reset_delims

	# Creates valid stmt delim, empty comment delim
	# Sets default flag for comment delim
	#
	[[ -n "${STMT_DELIM}"              ]]
	[[ -z "${COMMENT_DELIM}"           ]]
	[[ -n "${COMMENT_DELIM_UNDEFINED}" ]]

	reset_template_regexes

	# Defaults comment delim to stmt delim
	# Leaves default flag set for comment delim
	#
	[[    "${COMMENT_DELIM}" == "${STMT_DELIM}#" ]]
	[[ -n "${COMMENT_DELIM_UNDEFINED}"          ]]
}

@test "reset_template_regexes: creates template regexes" {

	reset_delims

	[[ -z "${DIRECTIVE_REGEX}"             ]]
	[[ -z "${COMMENT_REGEX}"               ]]
	[[ -z "${STATEMENT_REGEX}"             ]]
	[[ -z "${STATEMENT_BLOCK_START_REGEX}" ]]
	[[ -z "${STATEMENT_BLOCK_STOP_REGEX}"  ]]
	[[ -z "${TEXT_REGEX}"                  ]]
	[[ -z "${TAG_TEXT_REGEX}"              ]]
	[[ -z "${TAG_STD_REGEX}"               ]]
	[[ -z "${TAG_QUOTE_REGEX}"             ]]
	[[ -z "${TAG_STATEMENT_REGEX}"         ]]

	reset_template_regexes

	# TODO Determine how to confirm that the value is a valid bash regex

	[[ -n "${DIRECTIVE_REGEX}"             ]]
	[[ -n "${COMMENT_REGEX}"               ]]
	[[ -n "${STATEMENT_REGEX}"             ]]
	[[ -n "${STATEMENT_BLOCK_START_REGEX}" ]]
	[[ -n "${STATEMENT_BLOCK_STOP_REGEX}"  ]]
	[[ -n "${TEXT_REGEX}"                  ]]
	[[ -n "${TAG_TEXT_REGEX}"              ]]
	[[ -n "${TAG_STD_REGEX}"               ]]
	[[ -n "${TAG_QUOTE_REGEX}"             ]]
	[[ -n "${TAG_STATEMENT_REGEX}"         ]]
}

@test "DIRECTIVE_REGEX: should fail on invalid directive line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ ! ""            =~ $DIRECTIVE_REGEX ]]
	[[ ! "DIRECTIVE"   =~ $DIRECTIVE_REGEX ]]
	[[ ! ". DIRECTIVE" =~ $DIRECTIVE_REGEX ]]

	#
	# Custom delim
	#

	parse_directive_delim '@'
	reset_template_regexes

	[[ ! ".DIRECTIVE" =~ $DIRECTIVE_REGEX ]]
}

@test "DIRECTIVE_REGEX: should match on valid directive line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ ".DIRECTIVE" =~ $DIRECTIVE_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == ''          ]]
	[[ "${BASH_REMATCH[2]}" == 'DIRECTIVE' ]]
	[[ "${BASH_REMATCH[3]}" == ''          ]]

	[[ ".My_Directive" =~ $DIRECTIVE_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == ''             ]]
	[[ "${BASH_REMATCH[2]}" == 'My_Directive' ]]
	[[ "${BASH_REMATCH[3]}" == ''             ]]

	[[ ".my-directive" =~ $DIRECTIVE_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == ''             ]]
	[[ "${BASH_REMATCH[2]}" == 'my-directive' ]]
	[[ "${BASH_REMATCH[3]}" == ''             ]]

	[[ ".DIRECTIVE arg1 arg2 " =~ $DIRECTIVE_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''                  ]]
	[[ "${BASH_REMATCH[2]}" == 'DIRECTIVE'         ]]
	[[ "${BASH_REMATCH[3]}" == ' arg1 arg2 '       ]]

	[[ "    .DIRECTIVE" =~ $DIRECTIVE_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '       ]]
	[[ "${BASH_REMATCH[2]}" == 'DIRECTIVE'  ]]
	[[ "${BASH_REMATCH[3]}" == ''           ]]

	[[ "    .my_directive arg = value " =~ $DIRECTIVE_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '                       ]]
	[[ "${BASH_REMATCH[2]}" == 'my_directive'               ]]
	[[ "${BASH_REMATCH[3]}" == ' arg = value '              ]]

	#
	# Custom delim
	#

	parse_directive_delim '@@'
	reset_template_regexes

	[[ "@@DIRECTIVE" =~ $DIRECTIVE_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == ''           ]]
	[[ "${BASH_REMATCH[2]}" == 'DIRECTIVE'  ]]
	[[ "${BASH_REMATCH[3]}" == ''           ]]

	[[ "@@My_Directive" =~ $DIRECTIVE_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == ''              ]]
	[[ "${BASH_REMATCH[2]}" == 'My_Directive'  ]]
	[[ "${BASH_REMATCH[3]}" == ''              ]]

	[[ "@@my-directive" =~ $DIRECTIVE_REGEX    ]]
	[[ "${BASH_REMATCH[1]}" == ''              ]]
	[[ "${BASH_REMATCH[2]}" == 'my-directive'  ]]
	[[ "${BASH_REMATCH[3]}" == ''              ]]

	[[ "@@DIRECTIVE arg1 arg2 " =~ $DIRECTIVE_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''                   ]]
	[[ "${BASH_REMATCH[2]}" == 'DIRECTIVE'          ]]
	[[ "${BASH_REMATCH[3]}" == ' arg1 arg2 '        ]]

	[[ "    @@DIRECTIVE" =~ $DIRECTIVE_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '        ]]
	[[ "${BASH_REMATCH[2]}" == 'DIRECTIVE'   ]]
	[[ "${BASH_REMATCH[3]}" == ''            ]]

	[[ "    @@my_directive arg = value " =~ $DIRECTIVE_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '                        ]]
	[[ "${BASH_REMATCH[2]}" == 'my_directive'                ]]
	[[ "${BASH_REMATCH[3]}" == ' arg = value '               ]]
}

@test "COMMENT_REGEX: should fail on invalid comment line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ ! ""          =~ $COMMENT_REGEX ]]
	[[ ! "comment"   =~ $COMMENT_REGEX ]]
	[[ ! ".#comment" =~ $COMMENT_REGEX ]]

	#
	# Custom delim
	#

	parse_comment_delim '//'
	reset_template_regexes

	[[ ! "#comment" =~ $COMMENT_REGEX ]]
}

@test "COMMENT_REGEX: should match on valid comment line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ "%# Comment" =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''     ]]

	[[ "    %# Comment" =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '     ]]

	[[ "%#Comment"      =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''         ]]

	[[ "    %#Comment"  =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '     ]]

	#
	# Custom delim
	#

	parse_comment_delim '//'
	reset_template_regexes

	[[ "// Comment"     =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''         ]]

	[[ "    // Comment" =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '     ]]

	[[ "//Comment"      =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''         ]]

	[[ "    //Comment"  =~ $COMMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '     ]]
}

@test "STATEMENT_REGEX: should fail on invalid statement line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ ! ""           =~ $STATEMENT_REGEX ]]
	[[ ! "statement"  =~ $STATEMENT_REGEX ]]
	[[ ! "%"          =~ $STATEMENT_REGEX ]]
	[[ ! "%statement" =~ $STATEMENT_REGEX ]]

	parse_stmt_delim '$>'
	reset_template_regexes

	[[ ! "$"           =~ $STATEMENT_REGEX ]]
	[[ ! "$>"          =~ $STATEMENT_REGEX ]]
	[[ ! "$>statement" =~ $STATEMENT_REGEX ]]
	[[ ! "% statement" =~ $STATEMENT_REGEX ]]
}

@test "STATEMENT_REGEX: should match on valid statement line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ "% statement"     =~ $STATEMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''            ]]
	[[ "${BASH_REMATCH[2]}" == 'statement'    ]]

	[[ "    % statement" =~ $STATEMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '        ]]
	[[ "${BASH_REMATCH[2]}" == 'statement'   ]]

	[[ "    % statement with args" =~ $STATEMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '                  ]]
	[[ "${BASH_REMATCH[2]}" == 'statement with args'   ]]

	#
	# Custom delim
	#

	parse_stmt_delim '$>'
	reset_template_regexes

	[[ "$> statement"     =~ $STATEMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''             ]]
	[[ "${BASH_REMATCH[2]}" == 'statement'    ]]

	[[ "    $> statement with args" =~ $STATEMENT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '                   ]]
	[[ "${BASH_REMATCH[2]}" == 'statement with args'    ]]
}

@test "STATEMENT_BLOCK_START_REGEX: should fail on invalid statement block start line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ ! ""           =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ ! "."          =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ ! "%statement" =~ $STATEMENT_BLOCK_START_REGEX ]]

	#
	# Custom delim
	#

	parse_stmt_block_delims '<% %>'
	reset_template_regexes

	[[ ! "<"           =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ ! "%"           =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ ! "<%statement" =~ $STATEMENT_BLOCK_START_REGEX ]]

}

@test "STATEMENT_BLOCK_START_REGEX: should match on valid statement block start line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ "%"      =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''               ]]

	[[ "% "     =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''               ]]

	[[ "    %"  =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '           ]]

	[[ "    % " =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '           ]]

	#
	# Custom delim
	#

	parse_stmt_block_delims '<% %>'
	reset_template_regexes

	[[ "<%"      =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''                ]]

	[[ "<% "     =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''                ]]

	[[ "    <%"  =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '            ]]

	[[ "    <% " =~ $STATEMENT_BLOCK_START_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '            ]]
}

@test "STATEMENT_BLOCK_STOP_REGEX: should fail on invalid statement block stop line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ ! ""           =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ ! "."          =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ ! "%statement" =~ $STATEMENT_BLOCK_STOP_REGEX ]]

	#
	# Custom delim
	#

	parse_stmt_block_delims '<% %>'
	reset_template_regexes

	[[ ! ">"           =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ ! "%"           =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ ! "%>statement" =~ $STATEMENT_BLOCK_STOP_REGEX ]]
}

@test "STATEMENT_BLOCK_STOP_REGEX: should match on valid statement block stop line" {
	#
	# Default delim
	#

	reset_delims
	reset_template_regexes

	[[ "%"      =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''              ]]

	[[ "% "     =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''              ]]

	[[ "    %"  =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '          ]]

	[[ "    % " =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '          ]]

	#
	# Custom delim
	#

	parse_stmt_block_delims '<% %>'
	reset_template_regexes

	[[ "%>"      =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''               ]]

	[[ "%> "     =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ''               ]]

	[[ "    %>"  =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '           ]]

	[[ "    %> " =~ $STATEMENT_BLOCK_STOP_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '    '           ]]

}

@test "TEXT_REGEX: should match ALL input" {
	reset_delims
	reset_template_regexes

	[[ ""        =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ " "       =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ "  "      =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '  ' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ "   "     =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '   ' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ "%"       =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '' ]]
	[[ "${BASH_REMATCH[2]}" == '%' ]]

	[[ " %"      =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '%' ]]

	[[ " % "     =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '% ' ]]

	[[ "ab"      =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '' ]]
	[[ "${BASH_REMATCH[2]}" == 'ab' ]]

	[[ " ab"     =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == 'ab' ]]

	[[ "ab "     =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '' ]]
	[[ "${BASH_REMATCH[2]}" == 'ab ' ]]

	[[ " ab "    =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == 'ab ' ]]

	[[ "a b c"   =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '' ]]
	[[ "${BASH_REMATCH[2]}" == 'a b c' ]]

	[[ " a b c"  =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == 'a b c' ]]

	[[ "a b c "  =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '' ]]
	[[ "${BASH_REMATCH[2]}" == 'a b c ' ]]

	[[ " a b c " =~ $TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == 'a b c ' ]]
}


@test "TAG_TEXT_REGEX: should fail on invalid text tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ ! ""   =~ $TAG_TEXT_REGEX ]]
	[[ ! "<<" =~ $TAG_TEXT_REGEX ]]
	[[ ! "<%" =~ $TAG_TEXT_REGEX ]]

	#
	# Custom Delims
	#

	parse_tag_delims "{{ }}"
	reset_template_regexes

	[[ ! ""    =~ $TAG_TEXT_REGEX ]]
	[[ ! "{{"  =~ $TAG_TEXT_REGEX ]]
}

@test "TAG_TEXT_REGEX: should match on valid text tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ " "  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ "<"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '<' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ "< "  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '< ' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ " <"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '<' ]]

	[[ " <<"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '<<' ]]

	[[ " <%"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '<%' ]]

	[[ "some text"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ "some text <"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '<' ]]

	[[ "some text < "  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '< ' ]]

	[[ "some text <<"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '<<' ]]

	[[ "some text <%"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '<%' ]]

	[[ "some text <% "  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '<% ' ]]

	#
	# Custom Delims
	#

	parse_tag_delims "{{ }}"
	reset_template_regexes

	[[ "{"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '{' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ "{ "  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == '{ ' ]]
	[[ "${BASH_REMATCH[2]}" == '' ]]

	[[ " {{"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == ' ' ]]
	[[ "${BASH_REMATCH[2]}" == '{{' ]]

	[[ "some text {"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '{' ]]

	[[ "some text { "  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '{ ' ]]

	[[ "some text {{"  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '{{' ]]

	[[ "some text {{ "  =~ $TAG_TEXT_REGEX ]]
	[[ "${BASH_REMATCH[1]}" == 'some text ' ]]
	[[ "${BASH_REMATCH[2]}" == '{{ ' ]]
}

@test "TAG_STD_REGEX: should fail on invalid std script tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ ! ""         =~ $TAG_STD_REGEX ]]
	[[ ! " "        =~ $TAG_STD_REGEX ]]
	[[ ! "<"        =~ $TAG_STD_REGEX ]]
	[[ ! "<%"       =~ $TAG_STD_REGEX ]]
	[[ ! "<%>"      =~ $TAG_STD_REGEX ]]
	[[ ! "<% >"     =~ $TAG_STD_REGEX ]]
	[[ ! "<% tag >" =~ $TAG_STD_REGEX ]]
	[[ ! "<% % >"   =~ $TAG_STD_REGEX ]]

	#
	# Custom Delims
	#

	parse_tag_delims "{{ }}"
	reset_template_regexes

	[[ ! "{"        =~ $TAG_STD_REGEX ]]
	[[ ! "{}"       =~ $TAG_STD_REGEX ]]
	[[ ! "{{"       =~ $TAG_STD_REGEX ]]
	[[ ! "{{}"      =~ $TAG_STD_REGEX ]]
	[[ ! "{}}"      =~ $TAG_STD_REGEX ]]
	[[ ! "{{ }"     =~ $TAG_STD_REGEX ]]
	[[ ! "{  }}"    =~ $TAG_STD_REGEX ]]
	[[ ! "{ }"      =~ $TAG_STD_REGEX ]]
	[[ ! "{{ tag }" =~ $TAG_STD_REGEX ]]
	[[ ! "{{ } }"   =~ $TAG_STD_REGEX ]]
}

@test "TAG_STD_REGEX: should match on valid std script tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ "<%%>"        =~ $TAG_STD_REGEX ]]
	[[ "<% %>"       =~ $TAG_STD_REGEX ]]
	[[ "<%  %>"      =~ $TAG_STD_REGEX ]]
	[[ "<%tag%>"     =~ $TAG_STD_REGEX ]]
	[[ "<% tag%>"    =~ $TAG_STD_REGEX ]]
	[[ "<%tag %>"    =~ $TAG_STD_REGEX ]]
	[[ "<% tag %>"   =~ $TAG_STD_REGEX ]]
	[[ "<%%%>"       =~ $TAG_STD_REGEX ]]
	[[ "<% %%>"      =~ $TAG_STD_REGEX ]]
	[[ "<%% %>"      =~ $TAG_STD_REGEX ]]
	[[ "<% % %>"     =~ $TAG_STD_REGEX ]]
	[[ "<%%%%>"      =~ $TAG_STD_REGEX ]]
	[[ '<% $HOME %>' =~ $TAG_STD_REGEX ]]

	#
	# Custom Delims
	#

	parse_tag_delims "{{ }}"
	reset_template_regexes

	[[ "{{}}"       =~ $TAG_STD_REGEX ]]
	[[ "{{ }}"      =~ $TAG_STD_REGEX ]]
	[[ "{{  }}"     =~ $TAG_STD_REGEX ]]
	[[ "{{tag}}"    =~ $TAG_STD_REGEX ]]
	[[ "{{ tag}}"   =~ $TAG_STD_REGEX ]]
	[[ "{{tag }}"   =~ $TAG_STD_REGEX ]]
	[[ "{{ tag }}>" =~ $TAG_STD_REGEX ]]
	[[ "{{}}}"      =~ $TAG_STD_REGEX ]]
	[[ "{{ }}}"     =~ $TAG_STD_REGEX ]]
	[[ "{{} }}"     =~ $TAG_STD_REGEX ]]
	[[ "{{ } }}"    =~ $TAG_STD_REGEX ]]
	[[ "{{}}}}}"    =~ $TAG_STD_REGEX ]]
}

@test "TAG_QUOTE_REGEX: should fail on invalid quote script tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ ! ""          =~ $TAG_QUOTE_REGEX ]]
	[[ ! " "         =~ $TAG_QUOTE_REGEX ]]
	[[ ! "<"         =~ $TAG_QUOTE_REGEX ]]
	[[ ! "<>"        =~ $TAG_QUOTE_REGEX ]]
	[[ ! "<%"        =~ $TAG_QUOTE_REGEX ]]
	[[ ! "<%>"       =~ $TAG_QUOTE_REGEX ]]
	[[ ! "<% %>"     =~ $TAG_QUOTE_REGEX ]]
	[[ ! "<% tag %>" =~ $TAG_QUOTE_REGEX ]]
	[[ ! '<%"%>'     =~ $TAG_QUOTE_REGEX ]]
	[[ ! '<%" " %>'  =~ $TAG_QUOTE_REGEX ]]

	#
	# Custom Delims
	#

	parse_tag_delims "{{ }}"
	reset_template_regexes

	[[ ! "{"         =~ $TAG_QUOTE_REGEX ]]
	[[ ! "{}"        =~ $TAG_QUOTE_REGEX ]]
	[[ ! "{{"        =~ $TAG_QUOTE_REGEX ]]
	[[ ! "{{}"       =~ $TAG_QUOTE_REGEX ]]
	[[ ! "{}}"       =~ $TAG_QUOTE_REGEX ]]
	[[ ! "{{ }}"     =~ $TAG_QUOTE_REGEX ]]
	[[ ! "{{ tag }}" =~ $TAG_QUOTE_REGEX ]]
	[[ ! '{{"}}'     =~ $TAG_QUOTE_REGEX ]]
	[[ ! '{{" " }}'  =~ $TAG_QUOTE_REGEX ]]
}

@test "TAG_QUOTE_REGEX: should match on valid quote script tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ '<%""%>'      =~ $TAG_QUOTE_REGEX ]]

	[[ '<%""%>'      =~ $TAG_QUOTE_REGEX ]]
	[[ '<%"  "%>'    =~ $TAG_QUOTE_REGEX ]]
	[[ '<%"tag"%>'   =~ $TAG_QUOTE_REGEX ]]
	[[ '<%" tag"%>'  =~ $TAG_QUOTE_REGEX ]]
	[[ '<%"tag "%>'  =~ $TAG_QUOTE_REGEX ]]
	[[ '<%" tag "%>' =~ $TAG_QUOTE_REGEX ]]
	[[ '<%"""%>'     =~ $TAG_QUOTE_REGEX ]]
	[[ '<%" ""%>'    =~ $TAG_QUOTE_REGEX ]]
	[[ '<%"" "%>'    =~ $TAG_QUOTE_REGEX ]]
	[[ '<%" " "%>'   =~ $TAG_QUOTE_REGEX ]]
	[[ '<%""""%>'    =~ $TAG_QUOTE_REGEX ]]

	#
	# Custom Delims
	#

	parse_tag_delims "{{ }}"
	reset_template_regexes

	[[ '{{""}}'        =~ $TAG_QUOTE_REGEX ]]
	[[ '{{" "}}'       =~ $TAG_QUOTE_REGEX ]]
	[[ '{{"  "}}'      =~ $TAG_QUOTE_REGEX ]]
	[[ '{{"tag"}}'     =~ $TAG_QUOTE_REGEX ]]
	[[ '{{" tag"}}'    =~ $TAG_QUOTE_REGEX ]]
	[[ '{{"tag "}}'    =~ $TAG_QUOTE_REGEX ]]
	[[ '{{" tag "}}>'  =~ $TAG_QUOTE_REGEX ]]
	[[ '{{"""}}'       =~ $TAG_QUOTE_REGEX ]]
	[[ '{{" ""}}'      =~ $TAG_QUOTE_REGEX ]]
	[[ '{{"" "}}'      =~ $TAG_QUOTE_REGEX ]]
	[[ '{{" " "}}'     =~ $TAG_QUOTE_REGEX ]]
	[[ '{{"""""}}'     =~ $TAG_QUOTE_REGEX ]]
}

@test "TAG_STATEMENT_REGEX: should fail on invalid statement script tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ ! ""          =~ $TAG_STATEMENT_REGEX ]]
	[[ ! " "         =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<"         =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<%"        =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<%>"       =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<% %>"     =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<% tag %>" =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<% % %>"   =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<%% %%>"   =~ $TAG_STATEMENT_REGEX ]] # TODO

	#
	# Custom Delims
	#

	parse_tag_stmt_delim "$"
	reset_template_regexes

	[[ ! "<%% %>"   =~ $TAG_STATEMENT_REGEX ]]
	[[ ! "<% $ %>"  =~ $TAG_STATEMENT_REGEX ]]
}

@test "TAG_STATEMENT_REGEX: should match on valid statement script tag" {
	#
	# Default Delims
	#

	reset_delims
	reset_template_regexes

	[[ "<%%%>"      =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%% %>"     =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%%  %>"    =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%%tag%>"   =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%% tag%>"  =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%%tag %>"  =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%% tag %>" =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%% %>"     =~ $TAG_STATEMENT_REGEX ]]
	[[ "<%% % %>"   =~ $TAG_STATEMENT_REGEX ]]

	#
	# Custom Delims
	#

	parse_tag_stmt_delim "$"
	reset_template_regexes

	[[ '<%$%>'       =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$ %>'      =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$  %>'     =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$tag%>'    =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$ tag%>'   =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$tag %>'   =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$ $tag %>' =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$$ $%>'    =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$$ $ %>'   =~ $TAG_STATEMENT_REGEX ]]
	[[ '<%$$$%>'     =~ $TAG_STATEMENT_REGEX ]]
}
