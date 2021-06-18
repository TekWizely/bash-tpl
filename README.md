# Bash-TPL [![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/tekwizely/pre-commit-golang/blob/master/LICENSE)

A Smart, Lightweight shell script templating engine, written in Bash.

Bash-TPL lets you you mark up textual files (config files, yaml, xml, scripts, html, etc) with shell commands and variable replacements, while minimally impacting your original file layout.

Templates are compiled into shell scripts that you can invoke (along with variables, arguments, etc) to generate complete and well-formatted output text files.

#### Lightwight

Bash-TPL is presented as a single-file Bash script, making it both easy to bring along with your projects, and even easier to use, since there is no need to compile any source code.

#### Smart

Bash-TPL encourages you to use extra indentation to write clean, well-formatted templates, and smartly removes the indentations from the generated template scripts.

This results in both templates that are easily readable and maintainable, and generated text files that look as good as if they were written by hand.

*NOTE: Consistent Formatting*

The key to success with Bash-TPL's indentation fix-up logic is _Consistent Formatting_ - using consistent indentation throughout your template will yield best results.

### Text Tags

#### Standard Tag

_test.tpl_
```
Hello <% $NAME %>
```

```sh
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello TekWizely
```

#### Quote Tag

_test.tpl_
```
Hello <%" <% $NAME %> "%>
```

```sh
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello <% TekWizely %>
```

#### Script Tag

_test.tpl_
```
Hello <%% echo $NAME | tr '[:lower:]' '[:upper:]' %>
```

```sh
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello TEKWIZELY
```

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
      %INCLUDE include.tpl
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
