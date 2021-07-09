# Bash-TPL [![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/tekwizely/pre-commit-golang/blob/master/LICENSE)

A Smart, Lightweight shell script templating engine, written in Bash.

Bash-TPL lets you you mark up textual files (config files, yaml, xml, scripts, html, etc) with shell commands and variable replacements, while minimally impacting your original file layout.

Templates are compiled into shell scripts that you can invoke (along with variables, arguments, etc) to generate complete and well-formatted output text files.

#### Features

##### Lightweight

Bash-TPL is presented as a single-file Bash script, making it both easy to bring along with your projects, and even easier to use, since there is no need to compile any source code.

See [Adding `bash-tpl` into your project](#adding-bash-tpl-into-your-project) for more information.

##### Smart

Bash-TPL encourages you to use extra indentation to write clean, well-formatted templates, and smartly removes the indentations from the generated template scripts.

This results in both templates that are easily readable and maintainable, and generated text files that look as good as if they were written by hand.

*NOTE: Consistent Formatting*

The key to success with Bash-TPL's indentation fix-up logic is _Consistent Formatting_ - using consistent indentation throughout your template will yield best results.


##### Non-Bash-Specific

The shell scripts that Bash-TPL generates are not intended to be Bash-specific.

Any shell that can process the following statement should be compatible:

```
printf "%s\n" Plain\ text\,\ "$VARIABLE"\,\ "$(echo subshell)"
```

#### TOC

- [Template Tags](#template-tags)
  - [Text Tags](#text-tags)
  - [Statement Lines](#statement-lines)
  - [Statement Blocks](#statement-blocks)
  - [Template Comments](#template-comments)
- [Directives](#directives)
  - [INCLUDE](#include)
  - [DELIMS](#delims)
  - [RESET-DELIMS](#reset-delims)
- [Customizing Delimiters](#customizing-delimiters)
- [Resetting Delimiters](#resetting-delimiters)
- [Installing](#installing)
- [Contributing](#contributing)
- [Contact](#contact)
- [License](#license)
  - [Adding `bash-tpl` into your project](#adding-bash-tpl-into-your-project)

--------
## Using

bash-tpl takes a single template file as input and generates a shell script as output.

_basic usage_

```
$ bash-tpl my_template.tpl > my_script.sh
```

#### Specifying Output File

You can sepecify the output file using the `-o` or `--output-file` options:

```
$ bash-tpl --output-file my_script.sh my_template.tpl
```

#### Display Version

_display bash-tpl version_

```
$ bash-tpl --version
```

#### Full Usage Screen

You can view the full usage screen using the `-h` or `--help` options, or simply by invoking bash-tpl with no options:
```
$ bash-tpl --help
```

----------------
## Template Tags

### Text Tags

Text tags allow you to seamlessly inject dynamic data elements inline with your text.

They allow you to maintain your template as nicely-formatted text instead of complicated print statements, ie:

```
Hello <% $NAME %>
```

Is equivalent to :

```
printf "%s\n" Hello\ "$NAME"
```

**Default Delimiters:**

The default delimiters for text tags are `<%` &amp; `%>`

See the [Customizing Delimiters](#customizing-delimiters) section to learn about the many ways you can customize delimiters to your liking.

##### Example

_test.tpl_
```
Hello '<% $NAME %>'
```

```
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello 'TekWizely'
```

##### Trimming

**NOTE:** For standard tags, The value within the delimiters is 'trimmed' before being processed, ie: `'<% $NAME %>'` is equivalent to `'<%$NAME%>'`.

This is to encourage you to use liberal amounts of whitespace, keeping your templates easy to read and maintain.

If you require leading and/or trailing space to be processed, see [quote tags](#quote-tag).

#### Quote Tag

Quote tags are similar to standard tags, with the exception that *no trimming* is performed, and leading/trailing whitespace is preserved, ie:

```
Hello <%" $NAME "%>
```

Is equivalent to :

```
printf "%s\n" Hello\ " $NAME "  # Whitespace around $NAME is preserved
```

**Delimiters:**

The delimiters for quote tags are `<%"` &amp; `"%>`

More specifically, the delimiters are : Standard delimiters with leading+trailing quotes (`"`)

NOTE: No whitespace is allowed between the standard tag and the quote character (ie. `<% "` would **not** be treated as a quote tag).

##### Example

_test.tpl_
```
Hello '<%" <% $NAME %> "%>'
```

```
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello ' <% TekWizely %> '
```

#### Statement Tag

Statement tags allow you to inline more-complicated script statements, ie:

```
Hello <%% echo $NAME %>
```

Is equivalent to :

```
printf "%s\n" Hello\ "$(echo $NAME)"  # Trivial example to demonstrate the conversion
```

**Delimiters:**

The delimiters for statement tags are `<%%` &amp; `%>`

More specifically, the delimiters are : Standard delimiters with the open delimiter followed by the statement tag delimiter.

**NOTES:**
* The statement tag delimiter (ie the 2nd `%`) can be configured separate from the standard tag delimiters. See [Customizing Delimiters](#customizing-delimiters) for details.
* No whitespace is allowed between the standard tag and the statement tag delimiter (ie. `<% %` would **not** be treated as a statement tag).
* The statement tag delimiter is *not* part of the close tag (`%>`), **just** the open tag (`<%%`)

##### Example

A *slightly* more useful example of a statement tag might be:

_test.tpl_
```
Hello <%% echo $NAME | tr '[:lower:]' '[:upper:]' %>
```

```
$ NAME=TekWizely source <( bash-tpl test.tpl )

Hello TEKWIZELY
```

##### Trimming

**NOTE:** As with standard tags, the value within the statement tag is 'trimmed' before being processed, ie: `'<%% echo $NAME %>'` is equivalent to `'<%%echo $NAME%>'`.

----------------
### Statement Lines

_test.tpl_
```
% [ -z "$1" ] && echo "Error: Missing argument" >&2 && return
Hello <% $1 %>
```

_test with no arguments_
```
$ source <( bash-tpl test.tpl )

Error: Missing argument
```

_test with argument_
```
$ source <( bash-tpl test.tpl ) TekWizely

Hello TekWizely
```

-----------------
### Statement Blocks

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
```
$ source <( bash-tpl test.tpl )

Error: Missing argument
```

_test with argument_
```
$ source <( bash-tpl test.tpl ) TekWizely

Hello TekWizely
```

---------------------
### Template Comments

_test.tpl_
```
%# This comment will be removed from the template script
% # This comment will remain as part of the template script
Hello world
```

_view raw template script_
```
$ bash-tpl test.tpl

# This comment will remain as part of the template script
printf "%s\n" Hello\ world
```

_invoke template script_
```
$ source <( bash-tpl test.tpl )

Hello world
```

--------------
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

```
$ source <( bash-tpl test.tpl ) a b c d

ARGS:
  - a
  - b
  - c
  - d
```

**NOTES:**
* The current delimiter configuration is passed to the included template
* You can pass command-line options (i.e `--tag-delims`, `--reset-delims`, etc)

#### DELIMS

Configure one or more template delimiters from *within* your template.

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

```
$ source <( bash-tpl test.tpl ) TekWizely

Hello TekWizely
```

**NOTES:**
* Both the `=` and Double-Quotes (`"`) shown in the example script are **required**
* The changes take affect immediately (i.e the very next line)
* The changes are passed along to any included templates

The DELIMS directive accepts the following parameters:

| PARAM            | FORMAT    | NOTE |
|------------------|-----------|------|
| TAG              | `".. .."` | two 2-char sequences, separated by a **single** space
| TAG-STMT         | `"."`     | 1 single character
| STMT             | `".+"`    | 1 or more characters
| STMT-BLOCK       | `".+ .+"` | two 1-or-more char sequences, separated by a **single** space
| DIR \| DIRECTIVE | `".+"`    | 1 or more characters
| CMT \| COMMENT   | `".+"`    | 1 or more characters


#### RESET-DELIMS

Reset **all** delimiters to their default values from *within* you template.

_test.tpl_
```
% echo "default statement delim"
.DELIMS stmt="$>"
$> echo "modified statement delim"
.RESET-DELIMS
% echo "back to default statement delim"
```

```
$ source <( bash-tpl test.tpl )

default statement delim
modified statement delim
back to default statement delim
```

--------------------------
### Customizing Delimiters

There are several ways to customize delimiters for your templates.

#### Environment Variables

You can change the default delimiters globally via the following environment variables:

| VARIABLE                   | FORMAT    | NOTE |
|----------------------------|-----------|------|
| BASH_TPL_TAG_DELIMS        | `".. .."` | two 2-char sequences, separated by a **single** space
| BASH_TPL_TAG_STMT_DELIM    | `"."`     | 1 single character
| BASH_TPL_STMT_DELIM        | `".+"`    | 1 or more characters
| BASH_TPL_STMT_BLOCK_DELIMS | `".+ .+"` | two 1-or-more char sequences, separated by a **single** space
| BASH_TPL_DIR_DELIM         | `".+"`    | 1 or more characters
| BASH_TPL_CMT_DELIM         | `".+"`    | 1 or more characters

##### quick example

_test.tpl_
```
%# customize text tag delimiter
Hello, {{ $1 }}
```

```
$ BASH_TPL_TAG_DELIMS="{{ }}" bash-tpl test.tpl > test.sh
$ . test.sh TekWizely

Hello, TekWizely
```

#### Command Line Options

The following command line options are available:

| OPTION              | FORMAT    | NOTE |
|---------------------|-----------|------|
| --tag-delims        | `".. .."` | two 2-char sequences, separated by a **single** space
| --tag-stmt-delim    | `"."`     | 1 single character
| --stmt-delim        | `".+"`    | 1 or more characters
| --stmt-block-delims | `".+ .+"` | two 1-or-more char sequences, separated by a **single** space
| --dir-delim \| --directive-delim | `".+"` | 1 or more characters
| --cmt-delim \| --comment-delim   | `".+"` | 1 or more characters

**NOTE:** Command-line options override environment variables.

##### quick example

_test.tpl_
```
%# customize text tag delimiter
Hello, {{ $1 }}
```

```
$ bash-tpl --tag-delims "{{ }}" test.tpl > test.sh
$ . test.sh TekWizely

Hello, TekWizely
```

#### DELIMS Directive

You can use the [DELIMS Directive](#delims) to configure delimiters from *within* your template.

**NOTE:** DELIMS options override both environment variables and command-line options.

### Resetting Delimiters

There are a couple of ways to reset the delimiters back to their default values.

#### Command-Line Option

You can use the `--reset-delims` option to reset the delimiters to defaults:

```
$ bash-tpl --reset-delims test.tpl
```

**NOTES:**
* Overrides environment variables
* Overrides any commend-line options that apperar *before* the `--reset-delims` option
* Does **not** override any command-line options that appear *afer* the `--reset-delims` option
* Can be passed as an option in an [INCLUDE](#include) directive, ie:
  ```
  .INCLUDE my_include.tpl --reset-delims
  ```

#### RESET-DELIMS Directive

You can use the [RESET-DELIMS Directive](#reset-delims) to reset delimiters from *within* your template.

-------------
## Installing

### Releases

See the [Releases](https://github.com/TekWizely/bash-tpl/releases) page for downloadable archives of versioned releases.

#### Brew Core
TBD

#### Brew Tap

In addition to working on brew core support, I have also created a tap to ensure the latest version is always available:

* https://github.com/TekWizely/homebrew-tap

_install bash-tpl directly from tap_
```
$ brew install tekwizely/tap/bash-tpl
```

_install tap to track updates_
```
$ brew tap tekwizely/tap

$ brew install bash-tpl
```

---------------
## Contributing

To contribute to Bash-TPL, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

----------
## Contact

If you want to contact me you can reach me at TekWize.ly@gmail.com.

----------
## License

The `tekwizely/bash-tpl` project is released under the [MIT](https://opensource.org/licenses/MIT) License.  See `LICENSE` file.

##### Adding `bash-tpl` into your project

The `bash-tpl` script has an embedded MIT [SPDX](https://spdx.org/licenses/MIT.html) header, as well as a license header, and should be safe for you to extract and add to your own projects for easy template generation.
