# Bash-TPL [![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/tekwizely/pre-commit-golang/blob/master/LICENSE)

A Smart, Lightweight shell script templating engine, written in Bash.

Bash-TPL lets you you mark up textual files (config files, yaml, xml, scripts, html, etc) with shell commands and variable replacements, while minimally impacting your original file layout.

Templates are compiled into shell scripts that you can invoke (along with variables, arguments, etc) to generate complete and well-formatted output text files.

#### Lightweight

Bash-TPL is presented as a single-file Bash script, making it both easy to bring along with your projects, and even easier to use, since there is no need to compile any source code.

#### Smart

Bash-TPL encourages you to use extra indentation to write clean, well-formatted templates, and smartly removes the indentations from the generated template scripts.

This results in both templates that are easily readable and maintainable, and generated text files that look as good as if they were written by hand.

*NOTE: Consistent Formatting*

The key to success with Bash-TPL's indentation fix-up logic is _Consistent Formatting_ - using consistent indentation throughout your template will yield best results.

## Template Tags

### Text Tags

Text tags allow you to seamlessly inject dynamic data elements inline with your text.

They allow you to maintain your template as nicely-formatted text instead of complicated print statements, ie:
```
Hello <% $NAME %>
```
Is equivalent to :
```sh
printf "%s\n" Hello\ "$NAME"
```

**Default Delimiters:**

The default delimiters for text tags are `<%` &amp; `%>`

See the [Customizing Delimiters](#customizing-delimiters) section to learn about the many ways you can customize delimiters to your liking.

##### Example

_test.tpl_
```
Hello <% $NAME %>
```

```sh
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello TekWizely
```

##### Trimming

**NOTE:** For standard tags, The value within the delimiters is 'trimmed' before being processed, ie: `'<% $NAME %>'` is equivalent to `'<%$NAME%>'`.

This is to encourage you to use liberal amounts of whitespace, keeping your templates easy to read and maintain.

If, for some reason, you require leading and/or trailing space to be processed, see the `"quote tag"` below.


#### Quote Tag

Quote tags are similar to standard tags, with the exception that *no trimming* is performed, and leading/trailing whitespace is preserved, ie:

```
Hello <%" $NAME "%>
```
Is equivalent to :
```sh
printf "%s\n" Hello\ " $NAME "  # White-space around $NAME is preserved
```

**Delimiters:**

The delimiters for quote tags are `<%"` &amp; `"%>`

More specifically, the delimiters are : Standard delimiters with leading+trailing quotes (`"`)

NOTE: No whitespace is allowed between the standard tag and the quote character (ie. `<% "` would **not** be treated as a quote tag).

##### Example

_test.tpl_
```
Hello <%" <% $NAME %> "%>
```

```sh
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello <% TekWizely %>
```

#### Script Tag

Script tags allow you to inline more-complicated script statements, ie:

```
Hello <%% echo $NAME %>
```
Is equivalent to :
```sh
printf "%s\n" Hello\ "$(echo $NAME)"  # Trivial example to demonstrate the conversion
```

**Delimiters:**

The delimiters for script tags are `<%%` &amp; `%>`

More specifically, the delimiters are : Standard delimiters with open delimiter followed by a [Script Line Delimiter](#script-lines).

NOTE: No whitespace is allowed between the standard tag and the script line delimiter (ie. `<% %` would **not** be treated as a script tag).

NOTE: The script line delimiter is *not* part of the close tag (`%>`), **just** the open tag (`<%%`)

##### Example

A *slightly* more useful example a script tag might be:

_test.tpl_
```
Hello <%% echo $NAME | tr '[:lower:]' '[:upper:]' %>
```

```sh
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello TEKWIZELY
```

##### Trimming

**NOTE:** As with standard tags, the value within the statement tag is 'trimmed' before being processed, ie: `'<%% echo $NAME %>'` is equivalent to `'<%%echo $NAME%>'`.

### Script Lines

_test.tpl_
```
% [ -z "$1" ] && echo "Error: Missing argument" >&2 && return
Hello <% $1 %>
```

_test with no arguments_
```sh
$ source <( bash-tpl test.tpl )

Error: Missing argument
```

_test with argument_
```sh
$ source <( bash-tpl test.tpl ) TekWizely

Hello TekWizely
```

### Script Blocks

```
%
    if [ -z "${1}" ]; then
        echo "Error: Missing argument" >&2
        return
    fi
%
Hello <% $1 %>
```

_test with no arguments_
```sh
$ source <( bash-tpl test.tpl )

Error: Missing argument
```

_test with argument_
```sh
$ source <( bash-tpl test.tpl ) TekWizely

Hello TekWizely
```

### Template Comments

_test.tpl_
```
%# This comment will be removed from the template script
% # This comment will remain as part of the template script
Hello world
```

_view raw template script_
```sh
$ bash-tpl test.tpl

# This comment will remain as part of the template script
printf "%s\n" Hello\ world
```

_invoke template script_
```sh
$ source <( bash-tpl test.tpl )

Hello world
```

### Directives

#### INCLUDE

_test.tpl_
```
ARGS:
  %# Due to smart indentation tracking,
  %# indentations within the while statement are removed.
  % while (( "$#" )); do
      %# Indentation is even tracked across includes
      .INCLUDE include.tpl
      % shift
  % done
```

_include.tpl_
```
- <% $1 %>
```

```sh
$ source <( bash-tpl test.tpl ) a b c d

ARGS:
  - a
  - b
  - c
  - d
```

#### DELIMS
_test.tpl_
```
%# We change the stmt block and tag delims
%# NOTE: Both the '=' and double-quotes (") are required
.DELIMS stmt-block="<% %>" tag="{{ }}"
<%
    if [ -z "${1}" ]; then
        echo "Error: Missing argument" >&2
        return
    fi
%>
Hello {{ $1 }}
```

_test with argument_
```sh
$ source <( bash-tpl test.tpl ) TekWizely

Hello TekWizely
```

##### Params

| PARAM            | FORMAT    | NOTE |
|------------------|-----------|------|
| TAG              | `".. .."` | two 2-char sequences, separated by a **single** space
| TAG-STMT         | `"."`     | 1 single character
| STMT             | `".+"`    | 1 or more characters
| STMT-BLOCK       | `".+ .+"` | two 1-or-more char sequences, separated by a **single** space
| DIR \| DIRECTIVE | `".+"`    | 1 or more characters
| CMT \| COMMENT   | `".+"`    | 1 or more characters

**NOTE** Both the `=` and Double-Quotes (`"`) shown in the example script are **required**.

#### RESET-DELIMS

_test.tpl_
```
% echo "default statement delim"
.DELIMS stmt="$>"
$> echo "modified statement delim"
.RESET-DELIMS
% echo "back to default statement delim"
```

```sh
$ source <( bash-tpl test.tpl )

default statement delim
modified statement delim
back to default statement delim
```
