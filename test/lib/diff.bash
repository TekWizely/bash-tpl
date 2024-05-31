###############################################################################
# Diff Helpers
# Compare values using diff to get contextual feedback on failure
###############################################################################

##
# diff_output - Diffs $output against stdin
#
# example:
#  diff_output <<< "expected value"
#
diff_output() {
	diff -a -u \
	--suppress-common-lines \
	--strip-trailing-cr \
	--label=EXPECTED - \
	--label=\$output <( printf "%s\n" "${output}" )
}

##
# diff_output_file - Diffs $output against specified file
# $1 = file containing expected content
#
# example:
#  diff_output_file "/path/to/file"
#
diff_output_file() {
	diff -a -u \
	--suppress-common-lines \
	--strip-trailing-cr \
	"${1}" \
	--label=\$output <( printf "%s\n" "${output}" )
}

##
# diff_stderr_file - Diffs $stderr against specified file
# $1 = file containing expected content
#
# example:
#  diff_stderr_file "/path/to/file"
#
diff_stderr_file() {
	diff -a -u \
	--suppress-common-lines \
	--strip-trailing-cr \
	"${1}" \
	--label=\$stderr <( printf "%s\n" "${stderr}" )
}

##
# diff_vars - Diffs two variables by reference
# $1 = varname of actual value
# $2 = varname of expected value
#
# example:
#  diff_vars actual expected
#
diff_vars() {
	diff -a -u \
	--suppress-common-lines \
	--strip-trailing-cr \
	--label=EXPECTED <( printf "%s" "${!2}" ) \
	--label=ACTUAL   <( printf "%s" "${!1}" )
}

##
# diff_vals - Diffs two values
# $1 = actual value
# $2 = expected value
#
# example:
#  diff_vals "${actual}" "expected value"
#
diff_vals() {
	diff -a -u \
	--suppress-common-lines \
	--strip-trailing-cr \
	--label=EXPECTED <( printf "%s" "${2}" ) \
	--label=ACTUAL   <( printf "%s" "${1}" )
}
