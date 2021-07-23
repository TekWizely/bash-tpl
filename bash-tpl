#!/usr/bin/env bash
#######################################################################
# SPDX-License-Identifier: MIT
# Copyright (c) 2021 TekWizely & co-authors
#
# Use of this source code is governed by the MIT license.
# See the accompanying LICENSE file, if present, or visit:
#   https://opensource.org/licenses/MIT
#######################################################################
VERSION="v0.3.0"
#######################################################################
# Bash-TPL: A Smart, Lightweight shell script templating engine
#
# Lets you you mark up textual files with shell commands and variable
# replacements, while minimally impacting your original file layout.
#
# Templates are compiled into shell scripts that you can invoke
# (along with variables, arguments, etc) to generate complete and
# well-formatted output text files.
#
#  Smart
#
# Encourages you to use extra indentation to write clean, well-
# formatted templates, and smartly removes the indentations from the
# generated template scripts.
#
# This results in both templates that are easily readable and
# maintainable, and generated text files that look as good as if they
# were written by hand.
#
#  NOTE: Consistent Formatting
#
# The key to success with Bash-TPL's indentation fix-up logic is
# Consistent Formatting; using consistent indentation throughout your
# template will yield best results.
#
# Learn More:
#   https://github.com/TekWizely/bash-tpl
#######################################################################

function usage() {
	cat << USAGE
Bash-TPL is a smart, lightweight shell script templating engine

usage: bash-tpl [flags] [--] file
       bash-tpl [flags] -
       cat file | bash-tpl [flags]

options:
  -h, --help
        show help screen
  --version
        show version
  -o, --output-file <filename>
        write to specified file (default: stdout)
   --   treat reamining options as positional arguments
   -    read from stdin

customize delimiters:
  --tag-delims 'xx xx'
        set tag delimiters (default: '<% %>')
  --tag-stmt-delim 'x'
        set tag statement delimiter (default: '%')
  --stmt-delim 'x+'
        set statement delimiter (default: '%')
  --stmt-block-delims 'x+ x+'
        set statement block delimiters
        defaults to statement delimiter if not explicitly set
  --dir-delim
  --directive-delim 'x+'
        set directive delimiter (default: '.')
  --cmt-delim
  --comment-delim 'x+'
        set template comment delimiter
        defaults to directive delimiter + '#' if not explicitly set
  --reset-delims
        reset all delimiters to defaults
        delim options provided after this option are honored

supported environment variables:
    BASH_TPL_TAG_DELIMS
    BASH_TPL_TAG_STMT_DELIM
    BASH_TPL_STMT_DELIM
    BASH_TPL_STMT_BLOCK_DELIMS
    BASH_TPL_DIR_DELIM
    BASH_TPL_CMT_DELIM

example:
    $ echo 'Hello <% \$NAME %>' > test.tpl
    $ NAME="Chuck Norris" source <( bash-tpl test.tpl )

    Hello Chuck Norris

learn more: https://github.com/TekWizely/bash-tpl

USAGE
}

#######################################################################
# Delim Functions
#######################################################################

TAG_DELIM_REGEX='^([^[:blank:]])([^[:blank:]]) ([^[:blank:]])([^[:blank:]])$'
TAG_STMT_DELIM_REGEX='^([^[:blank:]])$'
STMT_DELIM_REGEX='^([^[:blank:]]+)$'
STMT_BLOCK_DELIM_REGEX='^([^[:blank:]]+) ([^[:blank:]]+)$'

##
# reset_delims
#
function reset_delims() {
	TAG_START_DELIM1='<'
	TAG_START_DELIM2='%'
	TAG_STOP_DELIM1='%'
	TAG_STOP_DELIM2='>'

	TAG_STMT_DELIM='%'

	STMT_DELIM='%'

	STMT_BLOCK_DELIM_UNDEFINED=1
	STMT_BLOCK_START_DELIM=''
	STMT_BLOCK_STOP_DELIM=''

	DIRECTIVE_DELIM='.'

	COMMENT_DELIM_UNDEFINED=1
	COMMENT_DELIM=''
}

##
# parse_tag_delims
# $1 = delims
# $2 = src (for error msg)
#
function parse_tag_delims() {
	if [[ "${1}" =~ $TAG_DELIM_REGEX ]]; then
		TAG_START_DELIM1="${BASH_REMATCH[1]}"
		TAG_START_DELIM2="${BASH_REMATCH[2]}"
		TAG_STOP_DELIM1="${BASH_REMATCH[3]}"
		TAG_STOP_DELIM2="${BASH_REMATCH[4]}"
	else
		echo "Error: Invalid or missing tag delimiter values for ${2-tag delims}: '${1}'" >&2
		exit 1
	fi
}

##
# parse_tag_stmt_delims
# $1 = delim
# $2 = src (for error msg)
#
function parse_tag_stmt_delim() {
	if [[ "${1}" =~ $TAG_STMT_DELIM_REGEX ]]; then
		TAG_STMT_DELIM="${BASH_REMATCH[1]}"
	else
		echo "Error: Invalid or missing tag stmt delimiter value for ${2-tag stmt delim}: '${1}'" >&2
		exit 1
	fi
}

##
# parse_stmt_delim
# $1 = delim
# $2 = src (for error msg)
#
function parse_stmt_delim() {
	if [[ "${1}" =~ $STMT_DELIM_REGEX ]]; then
		STMT_DELIM="${BASH_REMATCH[1]}"
	else
		echo "Error: Invalid or missing stmt delimiter value for ${2:-stmt delim}: '${1}'" >&2
		exit 1
	fi
}

##
# parse_stmt_block_delims
# $1 = delims
# $2 = src (for error msg)
#
function parse_stmt_block_delims() {
	if [[ "${1}" =~ $STMT_BLOCK_DELIM_REGEX ]]; then
		STMT_BLOCK_START_DELIM="${BASH_REMATCH[1]}"
		STMT_BLOCK_STOP_DELIM="${BASH_REMATCH[2]}"
		STMT_BLOCK_DELIM_UNDEFINED=''
	else
		echo "Error: Invalid or missing stmt-block delimiter values for ${2:-stmt-block delims}: '${1}'" >&2
		exit 1
	fi
}

##
# parse_directive_delim - Uses STMT delim regex
# $1 = delim
# $2 = src (for error msg)
#
function parse_directive_delim() {
	if [[ "${1}" =~ $STMT_DELIM_REGEX ]]; then
		DIRECTIVE_DELIM="${1}"
	else
		echo "Error: Invalid or missing directive delimiter value for ${2:-dir delim}: '${1}'" >&2
		exit 1
	fi
}

##
# parse_comment_delim - Uses STMT delim regex
# $1 = delim
# $2 = src (for error msg)
#
function parse_comment_delim() {
	if [[ "${1}" =~ $STMT_DELIM_REGEX ]]; then
		COMMENT_DELIM="${1}"
		COMMENT_DELIM_UNDEFINED=''
	else
		echo "Error: Invalid or missing comment delimiter value for ${2:-cmt delim}: '${1}'" >&2
		exit 1
	fi
}

##
# reset_template_regexes
#
function reset_template_regexes() {
	# Fixup STMT_BLOCK delims - Default to STMT_DELIM if not set
	#
	if [[ -n "${STMT_BLOCK_DELIM_UNDEFINED}" ]]; then
		STMT_BLOCK_START_DELIM="${STMT_DELIM}"
		STMT_BLOCK_STOP_DELIM="${STMT_DELIM}"
	fi

	# Fixup COMMENT delim - Default to STMT_DELIM followed by '#' if not set
	#
	if [[ -n "${COMMENT_DELIM_UNDEFINED}" ]]; then
		COMMENT_DELIM="${STMT_DELIM}#"
	fi

	#
	# Create regexes
	#

	local d ds d1 d2 d3 d4

	d="${DIRECTIVE_DELIM}"
	escape_regex d
	DIRECTIVE_REGEX="^([[:blank:]]*)${d}([a-zA-Z_-]+)(.*)\$"

	d="${COMMENT_DELIM}"
	escape_regex d
	COMMENT_REGEX="^([[:blank:]]*)${d}"

	d="${STMT_DELIM}"
	escape_regex d
	STATEMENT_REGEX="^([[:blank:]]*)${d}[[:blank:]]+(.+)\$"

	d="${STMT_BLOCK_START_DELIM}"
	escape_regex d
	STATEMENT_BLOCK_START_REGEX="^([[:blank:]]*)${d}[[:blank:]]*\$"

	d="${STMT_BLOCK_STOP_DELIM}"
	escape_regex d
	STATEMENT_BLOCK_STOP_REGEX="^([[:blank:]]*)${d}[[:blank:]]*\$"

	TEXT_REGEX='^([[:blank:]]*)([^[:blank:]](.*))?$'

	d1="${TAG_START_DELIM1}"
	escape_regex d1

	d2="${TAG_START_DELIM2}"
	escape_regex d2

	d3="${TAG_STOP_DELIM1}"
	escape_regex d3

	d4="${TAG_STOP_DELIM2}"
	escape_regex d4

	ds="${TAG_STMT_DELIM}"
	escape_regex ds

	TAG_TEXT_REGEX="^([^${d1}]+|${d1}$|${d1}[^${d1}${d2}]+)(.*)"

	TAG_STD_REGEX="^${d1}${d2}((([^${d3}])|(${d3}[^${d4}]))*)${d3}${d4}(.*)"

	TAG_QUOTE_REGEX="^${d1}${d2}\"((([^\"])|(\"[^${d3}])|(\"${d3}[^${d4}]))*)\"${d3}${d4}(.*)"

	TAG_STATEMENT_REGEX="^${d1}${d2}${ds}((([^${d3}])|(${d3}[^${d4}]))*)${d3}${d4}(.*)"

	# printf "# ---> delim regexes:"
	# printf "# STATEMENT_BLOCK_START_REGEX: '%s'\n" "${STATEMENT_BLOCK_START_REGEX}"
	# printf "# STATEMENT_BLOCK_STOP_REGEX: '%s'\n" "${STATEMENT_BLOCK_STOP_REGEX}"
	# printf "# COMMENT_REGEX: '%s'\n" "${COMMENT_REGEX}"
	# printf "# DIRECTIVE_REGEX: '%s'\n" "${DIRECTIVE_REGEX}"
	# printf "# STATEMENT_REGEX: '%s'\n" "${STATEMENT_REGEX}"
	# printf "# TAG_TEXT_REGEX: '%s'\n" "${TAG_TEXT_REGEX}"
	# printf "# TAG_STD_REGEX: '%s'\n" "${TAG_STD_REGEX}"
	# printf "# TAG_QUOTE_REGEX: '%s'\n" "${TAG_QUOTE_REGEX}"
	# printf "# TAG_STATEMENT_REGEX: '%s'\n" "${TAG_STATEMENT_REGEX}"
}

#######################################################################
# Misc Functions
#######################################################################

##
# trim
# usage: trim varname
# NOTE: Expects value to NOT contain '\n'
#
function trim() {
	read -r "$1" <<< "${!1}"$'\n'
}

##
# escape_regex
# usage: escape_regex varname
#
function escape_regex() {
	local -n ref=$1
	# shellcheck disable=SC2001  # Too complex for ${variable//search/replace}
	# shellcheck disable=SC2016  # Not using expansion, prefer single quotes
	# shellcheck disable=SC2034  # ref is used
	ref=$(sed 's/[][\.|$()?+*^]/\\&/g' <<< "${!1}") # Omits: [{}]
}

##
# normalize_directive
# usage: normalize_directive varname
#
function normalize_directive() {
	local -n ref=$1
	# shellcheck disable=SC2034  # ref is used
	ref=$(tr 'a-z_' 'A-Z-' <<< "${!1}")
}

#######################################################################
# STATES
#######################################################################

STATES=()       # empty => DEFAULT
STATE="DEFAULT" # [ DEFAULT, MAYBE_TXT_BLOCK, TXT_BLOCK, START_STMT_BLOCK, STMT_BLOCK ]

##
# push_state
#
function push_state() {
	STATES+=("${1}")
}

##
# peek_state
#
function peek_state() {
	if [[ ${#STATES[@]} -gt 0 ]]; then
		STATE="${STATES[${#STATES[@]} - 1]}"
	else
		STATE="DEFAULT"
	fi
}

##
# pop_state
#
function pop_state() {
	if [[ ${#STATES[@]} -gt 0 ]]; then
		unset STATES[${#STATES[@]}-1]
	fi
}

#######################################################################
# STATEMENT_INDENTS
#######################################################################

STATEMENT_INDENTS=() # empty => ""
STATEMENT_INDENT=""

##
# push_statement_indent
#
function push_statement_indent() {
	STATEMENT_INDENTS+=("${1}")
}

##
# peek_statement_indent
#
function peek_statement_indent() {
	if [[ ${#STATEMENT_INDENTS[@]} -gt 0 ]]; then
		STATEMENT_INDENT="${STATEMENT_INDENTS[${#STATEMENT_INDENTS[@]} - 1]}"
	else
		STATEMENT_INDENT=""
	fi
}

##
# pop_statement_indent
#
function pop_statement_indent() {
	if [[ ${#STATEMENT_INDENTS[@]} -gt 0 ]]; then
		unset STATEMENT_INDENTS[${#STATEMENT_INDENTS[@]}-1]
	fi
}

#######################################################################
# TEXT_INDENTS
#######################################################################

TEXT_INDENTS=() # empty => ""

##
# push_text_indent
#
function push_text_indent() {
	TEXT_INDENTS+=("${1}")
}

##
# pop_text_indent
#
function pop_text_indent() {
	if [[ ${#TEXT_INDENTS[@]} -gt 0 ]]; then
		unset TEXT_INDENTS[${#TEXT_INDENTS[@]}-1]
	fi
}

#######################################################################
# PRINT_INDENTS
#######################################################################

PRINT_INDENTS=() # empty => ""

##
# push_print_indent
#
function push_print_indent() {
	PRINT_INDENTS+=("${1}")
}

##
# pop_print_indent
#
function pop_print_indent() {
	if [[ ${#PRINT_INDENTS[@]} -gt 0 ]]; then
		unset PRINT_INDENTS[${#PRINT_INDENTS[@]}-1]
	fi
}

#######################################################################
# Print Functions
#######################################################################

##
# print_statement_indent
#
function print_statement_indent() {
	printf "%s%s" "${BASE_STMT_INDENT}" "${1}"
}

##
# print_statement
#
function print_statement() {
	printf "%s\n" "${1}"
}

##
# print_statement_block_indent
#
function print_statement_block_indent() {
	local indent text_indent print_indent n
	indent="${1}"
	n=$((${#PRINT_INDENTS[@]} - 1))
	if [[ ${n} -ge 0 ]]; then
		text_indent="${TEXT_INDENTS[n]}"
		print_indent="${PRINT_INDENTS[n]}"
		if [[ "${indent}" == "${text_indent}"* ]]; then
			indent="${print_indent}${indent/#$text_indent/}"
		fi
	fi
	printf "%s%s" "${BASE_STMT_INDENT}" "${indent}"
}

##
# get_text_indent
#
function get_text_indent() {
	local indent text_indent print_indent n
	indent="${1}"
	n=$((${#PRINT_INDENTS[@]} - 1))
	while [[ ${n} -ge 0 ]]; do
		text_indent="${TEXT_INDENTS[n]}"
		print_indent="${PRINT_INDENTS[n]}"
		if [[ "${indent}" == "${text_indent}"* ]]; then
			indent="${print_indent}${indent/#$text_indent/}"
		else
			break
		fi
		((n -= 1))
	done
	printf "%s" "${indent}"
}

##
# print_text - generates a printf statement for template text
# $1 = leading indentation
# $2 = text
#
function print_text() {
	print_statement_indent "${1}"
	local indent
	indent=$(get_text_indent "$1")
	process_tags "${BASE_TEXT_INDENT}${indent}${2}"
}

#######################################################################
# Process Functions
#######################################################################

##
# process_tags
#
function process_tags() {
	local line args quoted
	line="${1}"
	args=""
	while [ -n "${line}" ]; do
		# echo "# LINE @ START: $(declare -p line)" >&2
		if [[ "${line}" =~ $TAG_TEXT_REGEX ]]; then
			# echo "# TEXT TAG MATCH: $(declare -p BASH_REMATCH)" >&2
			printf -v quoted "%q" "${BASH_REMATCH[1]}"
			args="${args}${quoted}"
			line="${BASH_REMATCH[2]}"
		elif [[ "${line}" =~ $TAG_QUOTE_REGEX ]]; then
			# echo "# QUOTE TAG MATCH: $(declare -p BASH_REMATCH)" >&2
			args="${args}\"${BASH_REMATCH[1]}\""
			line="${BASH_REMATCH[6]}"
		elif [[ "${line}" =~ $TAG_STATEMENT_REGEX ]]; then
			# echo "# STMT TAG MATCH: $(declare -p BASH_REMATCH)" >&2
			trim BASH_REMATCH[1]
			args="${args}\"\$(${BASH_REMATCH[1]})\""
			line="${BASH_REMATCH[5]}"
		# Check standard regex last as its a super-set of quote and stmt regex
		#
		elif [[ "${line}" =~ $TAG_STD_REGEX ]]; then
			# echo "# STD TAG MATCH: $(declare -p BASH_REMATCH)" >&2
			trim BASH_REMATCH[1]
			args="${args}\"${BASH_REMATCH[1]}\""
			line="${BASH_REMATCH[5]}"
		# Assume next character is TEXT - extract and process remainder
		#
		elif [[ "${line}" =~ (.)(.*) ]]; then
			# echo "# DEFAULT: Assuming first char is TEXT: $(declare -p line)"
			printf -v quoted "%q" "${BASH_REMATCH[1]}"
			args="${args}${quoted}"
			line="${BASH_REMATCH[2]}"
		fi
		# echo "# LINE @ END: $(declare -p line)" >&2
	done
	if [ -n "${args}" ]; then
		printf "printf \"%%s\\\\n\" %s\n" "${args}"
	else
		printf "printf \"\\\\n\"\n"
	fi
}

DELIM_DIR_TAG_REGEX='[Tt][Aa][Gg]\s*=\s*"([^"]*)"'
DELIM_DIR_TAG_STMT_REGEX='[Tt][Aa][Gg][_-]?[Ss][Tt][Mm][Tt]\s*=\s*"([^"]*)"'
DELIM_DIR_STMT_REGEX='[Ss][Tt][Mm][Tt]\s*=\s*"([^"]*)"'
DELIM_DIR_STMT_BLOCK_REGEX='[Ss][Tt][Mm][Tt][_-]?[Bb][Ll][Oo][Cc][Kk]\s*=\s*"([^"]*)"'
DELIM_DIR_DIR_REGEX='[Dd][Ii][Rr]\s*=\s*"([^"]*)"'
DELIM_DIR_DIRECTIVE_REGEX='[Dd][Ii][Rr][Ee][Cc][Tt][Ii][Vv][Ee]\s*=\s*"([^"]*)"'
DELIM_DIR_CMT_REGEX='[Cc][Mm][Tt]\s*=\s*"([^"]*)"'
DELIM_DIR_COMMENT_REGEX='[Cc][Oo][Mm][Mm][Ee][Nn][Tt]\s*=\s*"([^"]*)"'

##
# process_directive
# $1 = leading_indent
# $2 = directive
# $3 = directive arg(s)
#
function process_directive() {
	local directive stmt_indent text_indent
	directive="${2}"
	normalize_directive directive
	case "${directive}" in
		INCLUDE)
			stmt_indent="${1}"
			text_indent=$(get_text_indent "${1}")
			local args args_arr
			args="${3}"
			trim args
			declare -a "args_arr=(${args})"
			# shellcheck disable=SC2128  # We choose BASH_SOURCE vs BASH_SOURCE[0] for compatability
			"${BASH_SOURCE}" \
				--stmt-indent "${stmt_indent}" \
				--text-indent "${text_indent}" \
				--tag-delims "${TAG_START_DELIM1}${TAG_START_DELIM2} ${TAG_STOP_DELIM1}${TAG_STOP_DELIM2}" \
				--tag-stmt-delim "${TAG_STMT_DELIM}" \
				--stmt-delim "${STMT_DELIM}" \
				--stmt-block-delims "${STMT_BLOCK_START_DELIM} ${STMT_BLOCK_STOP_DELIM}" \
				--dir-delim "${DIRECTIVE_DELIM}" \
				--cmt-delim "${COMMENT_DELIM}" \
				"${args_arr[@]}"
			;;
		DELIMS)
			# TAG
			#
			if [[ "${3}" =~ $DELIM_DIR_TAG_REGEX ]]; then
				parse_tag_delims "${BASH_REMATCH[1]}" 'DELIMS TAG directive'
			fi
			# TAG-STMT
			#
			if [[ "${3}" =~ $DELIM_DIR_TAG_STMT_REGEX ]]; then
				parse_tag_stmt_delim "${BASH_REMATCH[1]}" 'DELIMS TAG-STMT directive'
			fi
			# STMT
			#
			if [[ "${3}" =~ $DELIM_DIR_STMT_REGEX ]]; then
				parse_stmt_delim "${BASH_REMATCH[1]}" 'DELIMS STMT directive'
			fi
			# STMT-BLOCK
			#
			if [[ "${3}" =~ $DELIM_DIR_STMT_BLOCK_REGEX ]]; then
				parse_stmt_block_delims "${BASH_REMATCH[1]}" '"DELIMS STMT-BLOCK directive'
			fi
			# DIRECTIVE
			#
			if [[ "${3}" =~ $DELIM_DIR_DIR_REGEX || "${3}" =~ $DELIM_DIR_DIRECTIVE_REGEX ]]; then
				parse_directive_delim "${BASH_REMATCH[1]}" 'DELIMS DIR directive'
			fi
			# COMMENT
			#
			if [[ "${3}" =~ $DELIM_DIR_CMT_REGEX || "${3}" =~ $DELIM_DIR_COMMENT_REGEX ]]; then
				parse_comment_delim "${BASH_REMATCH[1]}" 'DELIMS CMT directive'
			fi
			# Apply changes
			#
			reset_template_regexes
			;;
		RESET-DELIMS)
			reset_delims
			reset_template_regexes
			;;
		*) # unsupported directive
			echo "Error: Unknown directive: '${directive}' - Skipping" >&2
			;;
	esac
}

function process_stdin() {
	# local lineno
	# lineno=0 # 1 on first use
	while IFS="" read -r LINE || [ -n "${LINE}" ]; do
		# ((lineno += 1))
		# echo "#LINE NO          : ${lineno}"
		# echo "#LINE TEXT        : '${LINE}'"
		# echo "#STATE            : ${STATE}"
		# echo "#STATES           : $(declare -p STATES)"
		# echo "#STATEMENT_INDENTS: $(declare -p STATEMENT_INDENTS)"
		# echo "#TEXT_INDENTS     : $(declare -p TEXT_INDENTS)"
		# echo "#PRINT_INDENTS    : $(declare -p PRINT_INDENTS)"
		# echo -e "#>> ----------------\n"
		state_"${STATE}" "${LINE}"
	done
}

#######################################################################
# State Handler Functions
#######################################################################

##
# state_DEFAULT
# Not inside any blocks
# Assumes *_INDENT and STATE arrays are empty
#
function state_DEFAULT() {
	# Line is a statement
	#
	if [[ "${1}" =~ $STATEMENT_REGEX ]]; then
		push_statement_indent "${BASH_REMATCH[1]}"
		print_statement_indent "${BASH_REMATCH[1]}"
		print_statement "${BASH_REMATCH[2]}"
		STATE="MAYBE_TXT_BLOCK"
	# Line is a statement block start
	#
	elif [[ "${1}" =~ $STATEMENT_BLOCK_START_REGEX ]]; then
		push_statement_indent "${BASH_REMATCH[1]}"
		STATE="START_STMT_BLOCK"
	# Line is a directive
	#
	elif [[ "${1}" =~ $DIRECTIVE_REGEX ]]; then
		process_directive "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
	# Line is a comment
	#
	elif [[ "${1}" =~ $COMMENT_REGEX ]]; then
		: # Nothing to do, ignore the line
	# Line is text
	# NOTE : Check LAST because *everything* looks like text
	#
	elif [[ "${1}" =~ $TEXT_REGEX ]]; then
		print_text "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
	fi
}

##
# state_MAYBE_TXT_BLOCK
# Previous line was a statement
# We might be starting a text block
#
function state_MAYBE_TXT_BLOCK() {
	# Current line is also a statment
	#
	if [[ "${1}" =~ $STATEMENT_REGEX ]]; then
		peek_statement_indent
		# Current statement is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Prev statement IS a text block
			#
			push_text_indent "${BASH_REMATCH[1]}"
			push_print_indent "${STATEMENT_INDENT}"
			push_state "TXT_BLOCK"
			# Print curent statement with new indent
			#
			print_statement_indent "${BASH_REMATCH[1]}"
			print_statement "${BASH_REMATCH[2]}"
			# Current statement is Maybe a TXT Block
			#
			push_statement_indent "${BASH_REMATCH[1]}"
			STATE="MAYBE_TXT_BLOCK"
		# Current statement is NOT indented
		#
		else
			# Prev statement is NOT a text block
			# Discard saved state
			#
			pop_statement_indent
			peek_state
			# Re-process line in new state context
			#
			state_"${STATE}" "${1}"
		fi
	# Current line is a STMT Start Block
	#
	elif [[ "${1}" =~ $STATEMENT_BLOCK_START_REGEX ]]; then
		peek_statement_indent
		# Statement Start is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Prev statement IS a text block
			#
			push_text_indent "${BASH_REMATCH[1]}"
			push_print_indent "${STATEMENT_INDENT}"
			push_state "TXT_BLOCK"
			# Current statement is STMT Start Block
			#
			push_statement_indent "${BASH_REMATCH[1]}"
			STATE="START_STMT_BLOCK"
		# Current statement is NOT indented
		#
		else
			# Prev statement is NOT a text block
			# Discard saved state
			#
			pop_statement_indent
			peek_state
			# Re-process line in new state context
			#
			state_"${STATE}" "${1}"
		fi
	# Line is a directive
	#
	elif [[ "${1}" =~ $DIRECTIVE_REGEX ]]; then
		peek_statement_indent
		# Directive is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Prev statement IS a text block
			#
			push_text_indent "${BASH_REMATCH[1]}"
			push_print_indent "${STATEMENT_INDENT}"
			push_state "TXT_BLOCK"
			peek_state
			# Process directive
			#
			process_directive "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
		# Directive is NOT indented
		#
		else
			# Prev statement is NOT a text block
			# Discard saved state
			#
			pop_statement_indent
			peek_state
			# Re-process line in new state context
			#
			state_"${STATE}" "${1}"
		fi
	# Line is a comment
	# NOTE: For MAYBE_TXT_BLOCK, we allow comments to confirm/deny the text block
	#
	elif [[ "${1}" =~ $COMMENT_REGEX ]]; then
		# Comment is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Prev statement IS a text block
			#
			push_text_indent "${BASH_REMATCH[1]}"
			push_print_indent "${STATEMENT_INDENT}"
			push_state "TXT_BLOCK"
		# Comment is NOT indented
		#
		else
			# Prev statement is NOT a text block
			# Discard saved state
			#
			pop_statement_indent
			peek_state
		fi
		: # ignore the line
	# Line is text
	#
	elif [[ "${1}" =~ $TEXT_REGEX ]]; then
		peek_statement_indent
		# Text is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Prev statement IS a text block
			#
			push_text_indent "${BASH_REMATCH[1]}"
			push_print_indent "${STATEMENT_INDENT}"
			push_state "TXT_BLOCK"
			# Adjust and print
			#
			print_text "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
			peek_state
		# Text is NOT indented
		#
		else
			# Prev statement is NOT a text block
			# Discard saved state
			#
			pop_statement_indent
			peek_state
			# Re-process line in new state context
			#
			state_"${STATE}" "${1}"
		fi
	fi
}

##
# state_TXT_BLOCK
#
function state_TXT_BLOCK() {
	# Current line is a statment
	#
	if [[ "${1}" =~ $STATEMENT_REGEX ]]; then
		peek_statement_indent
		# Current statement is at same level as block-start statement
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}" ]]; then
			# End of text block
			# Discard saved state
			#
			pop_statement_indent
			pop_text_indent
			pop_print_indent
			pop_state
			peek_state
			# Print current statement
			#
			print_statement_indent "${BASH_REMATCH[1]}"
			print_statement "${BASH_REMATCH[2]}"
		# Current statement is indented
		#
		elif [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Print current statement
			#
			print_statement_indent "${BASH_REMATCH[1]}"
			print_statement "${BASH_REMATCH[2]}"
			# Current statement is Maybe a TXT Block
			#
			push_statement_indent "${BASH_REMATCH[1]}"
			STATE="MAYBE_TXT_BLOCK"
		# Current statement is NOT indented
		#
		else
			# Print leading indentation as-is
			# Do NOT treat statement as a MAYBE TEXT BlOCK
			#
			print_statement "${BASH_REMATCH[2]}"
		fi
	# Current line is a STMT Start Block
	#
	elif [[ "${1}" =~ $STATEMENT_BLOCK_START_REGEX ]]; then
		push_statement_indent "${BASH_REMATCH[1]}"
		STATE="START_STMT_BLOCK"
	# Current line is a directive
	#
	elif [[ "${1}" =~ $DIRECTIVE_REGEX ]]; then
		peek_statement_indent
		# Directive is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Process directive
			#
			process_directive "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
		fi
	# Line is a comment
	#
	elif [[ "${1}" =~ $COMMENT_REGEX ]]; then
		: # Nothing to do, ignore the line
	# Line is text
	#
	elif [[ "${1}" =~ $TEXT_REGEX ]]; then
		peek_statement_indent
		# Text is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Adjust and print
			#
			print_text "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
		# Text is NOT indented
		#
		else
			# Print leading indentation as-is
			#
			print_statement_indent "${BASH_REMATCH[1]}"
			process_tags "${1}"
		fi
	fi
}

##
# state_START_STMT_BLOCK
#
function state_START_STMT_BLOCK() {
	# Current line is a statement block end
	#
	if [[ "${1}" =~ $STATEMENT_BLOCK_STOP_REGEX ]]; then
		# End of statement block
		# Discard saved state
		#
		pop_statement_indent
		peek_state
	# Line is text (assumed to be a statement)
	#
	elif [[ "${1}" =~ $TEXT_REGEX ]]; then
		peek_statement_indent
		# Statement is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Statement Block has begun
			#
			push_text_indent "${BASH_REMATCH[1]}"
			push_print_indent "${STATEMENT_INDENT}"
			push_state "STMT_BLOCK"
			# Adjust and print
			#
			print_statement_block_indent "${BASH_REMATCH[1]}"
			print_statement "${BASH_REMATCH[2]}"
		# Statement is NOT indented
		#
		else
			push_text_indent ""
			push_print_indent ""
			push_state "STMT_BLOCK"
			# Print leading indentation as-is
			#
			print_statement_indent "${BASH_REMATCH[1]}"
			print_statement "${BASH_REMATCH[2]}"
		fi
		peek_state
	fi
}

##
# state_STMT_BLOCK
#
function state_STMT_BLOCK() {
	# Current line is a statement block end
	#
	if [[ "${1}" =~ $STATEMENT_BLOCK_STOP_REGEX ]]; then
		# End of statement block
		# Discard saved state
		#
		pop_statement_indent
		pop_text_indent
		pop_print_indent
		pop_state
		peek_state
	# Line is text (assumed to be a statement)
	#
	elif [[ "${1}" =~ $TEXT_REGEX ]]; then
		peek_statement_indent
		# Statement is indented
		#
		if [[ "${BASH_REMATCH[1]}" == "${STATEMENT_INDENT}"* && ${#BASH_REMATCH[1]} -gt ${#STATEMENT_INDENT} ]]; then
			# Adjust and print
			#
			print_statement_block_indent "${BASH_REMATCH[1]}"
			print_statement "${BASH_REMATCH[2]}"
		# Statement is NOT indented
		#
		else
			# Print leading indentation as-is
			#
			print_statement_indent "${BASH_REMATCH[1]}"
			print_statement "${BASH_REMATCH[2]}"
		fi
	fi
}

#######################################################################
# Main
#######################################################################

function version() {
	printf "%s\n" "${VERSION}"
}

##
# parse_env_delims - Set Delims from Environment Vars
#
function parse_env_delims() {
	if [ -n "${BASH_TPL_TAG_DELIMS}" ]; then
		parse_tag_delims "${BASH_TPL_TAG_DELIMS}" "BASH_TPL_TAG_DELIMS"
	fi

	if [ -n "${BASH_TPL_TAG_STMT_DELIM}" ]; then
		parse_tag_stmt_delim "${BASH_TPL_TAG_STMT_DELIM}" "BASH_TPL_TAG_STMT_DELIM"
	fi

	if [ -n "${BASH_TPL_STMT_DELIM}" ]; then
		parse_stmt_delim "${BASH_TPL_STMT_DELIM}" "BASH_TPL_STMT_DELIM"
	fi

	if [ -n "${BASH_TPL_STMT_BLOCK_DELIMS}" ]; then
		parse_stmt_block_delims "${BASH_TPL_STMT_BLOCK_DELIMS}" "BASH_TPL_STMT_BLOCK_DELIMS"
	fi

	if [ -n "${BASH_TPL_DIR_DELIM}" ]; then
		parse_directive_delim "${BASH_TPL_DIR_DELIM}" "BASH_TPL_DIR_DELIM"
	fi

	if [ -n "${BASH_TPL_CMT_DELIM}" ]; then
		parse_comment_delim "${BASH_TPL_CMT_DELIM}" "BASH_TPL_CMT_DELIM"
	fi
}

##
# parse_args
# $1 = remaining arg varname
# $2+ args to parse
#
function parse_args() {
	local -n __local_parse_args=$1 # nameref
	shift
	while (($#)); do
		case "$1" in
			-h | --help)
				usage
				exit 0
				;;
			--version)
				version
				exit 0
				;;
			-o | --output-file)
				if [ -n "${2}" ]; then
					OUPUT_FILE="${2}"
				else
					echo "Error: Invalid or missing value for --output-file: '${2}'" >&2
					exit 1
				fi
				shift 2
				;;
			--reset-delims)
				# Reset delims immediately - Any delim flags after this will be honored
				#
				reset_delims
				shift
				;;
			--tag-delims)
				parse_tag_delims "$2" "$1"
				shift 2
				;;
			--tag-stmt-delim)
				parse_tag_stmt_delim "$2" "$1"
				shift 2
				;;
			--stmt-delim)
				parse_stmt_delim "$2" "$1"
				shift 2
				;;
			--stmt-block-delims)
				parse_stmt_block_delims "$2" "$1"
				shift 2
				;;
			--dir-delim | --directive-delim)
				parse_directive_delim "$2" "$1"
				shift 2
				;;
			--cmt-delim | --comment-delim)
				parse_comment_delim "$2" "$1"
				shift 2
				;;
			--stmt-indent)
				BASE_STMT_INDENT="${2}"
				shift 2
				;;
			--text-indent)
				BASE_TEXT_INDENT="${2}"
				shift 2
				;;
			-)
				__local_parse_args+=("$1")
				shift
				;;
			--)
				shift
				while (($#)); do
					__local_parse_args+=("$1")
					shift
				done
				;;
			--* | -*) # unsupported flags
				echo "Error: unknown flag: '$1'; use -h for help" >&2
				exit 1
				;;
			*) # preserve positional arguments
				__local_parse_args+=("$1")
				shift
				;;
		esac
	done
}

function main() {

	OUPUT_FILE=""

	BASE_STMT_INDENT=""
	BASE_TEXT_INDENT=""

	reset_delims
	parse_env_delims

	args=()
	parse_args args "$@"
	set -- "${args[@]}"

	# No file argument
	#
	if [[ -z "${1}" ]]; then
		# Nothing waiting on stdin
		#
		if [[ -t 0 ]]; then
			usage
			exit 1
		fi
	else
		# File argument is explicitly stdin
		#
		if [[ "${1}" == '-' ]]; then
			shift
		else
			# File argument points to non existing/readable file
			#
			if [[ ! -r "${1}" ]]; then
				echo "File not found: '${1}'" >&2
				exit 1
			fi
			# File argument is good, re-route it to stdin
			#
			exec < "${1}"
			shift
		fi
	fi

	reset_template_regexes

	if [[ -n "${OUPUT_FILE}" ]]; then
		exec > "${OUPUT_FILE}"
	fi

	process_stdin
}

# Only process main logic if not being sourced (ie tested)
#
(return 0 2> /dev/null) || main "$@"
