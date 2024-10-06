# Bash-TPL [![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/tekwizely/pre-commit-golang/blob/master/LICENSE)

A Smart, lightweight shell script templating engine, written in Bash.

Bash-TPL lets you mark up textual files (config files, yaml, xml, scripts, html, etc.) with shell commands and variable replacements, while minimally impacting your original file layout.

Templates are compiled into shell scripts that you can invoke (along with variables, arguments, etc.) to generate complete and well-formatted output text files.

#### Features

##### Lightweight

Bash-TPL is presented as a single-file Bash script, making it both easy to bring along with your projects, and even easier to use, since there is no need to compile any source code.

See [Adding `bash-tpl` into your project](#adding-bash-tpl-into-your-project) for more information.

##### Smart Indentation Correction

Creating readable, maintainable templates often requires adding extra whitespace (i.e. indenting lines within a `for` loop) in order to help distinguish your template tags from your textual content.

Bash-TPL detects ands removes these extra indentations, resulting in generated text files that look as good as if they were written by hand !

*NOTE: Consistent Formatting*

The key to success with Bash-TPL's indentation fix-up logic is _Consistent Formatting_ - using consistent indentation throughout your templates will yield best results.

##### Generates Reusable Shell Scripts

The output of Bash-TPL is a reusable shell script that is then used to generate your final text document(s).

If desired, you could just bring/ship the intermediate script, with no further need for Bash-TPL until you need to make changes to your original template.

##### Shell Agnostic

The shell scripts that Bash-TPL generates are not intended to be Bash-specific.

Bash-TPL attempts to generate posix printf-compatible statements, utilizing `%s` and `%b`.

Any shell who's printf matches output below should be compatible:

```sh
$ VARIABLE=Variable
$ printf "%b%s%b%s%b\n" 'Text:\t\0047' "$VARIABLE" '\0047 "' "$(echo $VARIABLE)" '" $(\\n)'
```
```text
Text:	'Variable' "Variable" $(\n)
```

##### Custom Formatting

Although template tags are formatted with `%s` by default, you can customize their format using standard _printf_ format specifiers.

See [Formatting Text Tags](#formatting-text-tags) for more information.

##### Supports Includes

Templates can include other templates, making it easy to organize your templates as smaller, reusable components.

*NOTE:* Bash-TPL's smart indentation tracking &amp; correction even works across included templates !

The indentation of the `include` statement dictates the base indentation of the included file.

See [INCLUDE directive](#include) for more information.

##### Configurable Delimiters

Bash-TPL's default delimiters _should_ accommodate most text file formats without conflict.

But if you do run into conflicts, or if you just prefer a different style, the delimiters are fully configurable.

You can even modify delimiters mid-template !

See  [Customizing Delimiters](#customizing-delimiters) for more information.

*NOTE: Including Templates With Differing Delimiters*

You can easily include templates that have differing delimiters.

If the included template doesn't declare its delimiters explicitly (i.e. maybe it relies on the defaults), you can specify the delimiters as part of the include statement.

See [INCLUDE directive](#include) for more information.

##### Extensive Test Suite

Bash-TPL has an extensive test suite built wth [BATS](https://github.com/bats-core/bats-core)

*Older Bash Versions*

The test suite has been tested against Bash versions `3.2`, `4.4`, `5.0`, and `5.1`

#### TOC
- [Template Tags](#template-tags)
  - [Text Tags](#text-tags)
    - [Formatting Text Tags](#formatting-text-tags)
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

#### Reading From STDIN

In addition to files, bash-tpl can also read directly from `stdin`.

To read from `stdin`, use a single `-` as the input filename:

_stdin example_
```
$ bash-tpl - > hello.sh
Hello, world
^D
```

##### Other stdin sources

You can also use other common `stdin` sources:

_pipe example_
```
$ echo "Hello, world" | bash-tpl - > hello.sh
```

_herestring (`<<<`) example_
```
$ bash-tpl - <<< "Hello, world" > hello.sh
```

_heredoc (`<<`) example_
```
$ bash-tpl - > hello.sh <<EOF
Hello, world
EOF
```

**NOTE:** Use of `-` is optional for pipes and herestrings/docs. bash-tpl will try to auto-detect when they are being used.  But if you have any issues, an explicit `-` should help.

#### Specifying Output File

You can specify the output file using the `-o` or `--output-file` options:

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

#### Standard Tag

Here is a simple template example using the standard text tag:

_hello.tpl_
```
Hello <% $NAME %>
```

#### Processing The Template

We can process the template and review the generated script:

_process the template_
```
$ bash-tpl hello.tpl

printf "%b%s\n" 'Hello ' "$NAME"
```

#### Usage Example

Here's a quick example invoking the template-generated script along with some user data:

_usage example_
```
$ NAME=TekWizely source <( bash-tpl hello.tpl )

Hello TekWizely
```

##### Default Delimiters

The default delimiters for standard tags are `<%` &amp; `%>`

See the [Customizing Delimiters](#customizing-delimiters) section to learn about the many ways you can customize delimiters to your liking.

##### Trimming

**NOTE:** For standard tags, The value within the delimiters is 'trimmed' before being processed, ie: `'<% $NAME %>'` is equivalent to `'<%$NAME%>'`.

This is to encourage you to use liberal amounts of whitespace, keeping your templates easy to read and maintain.

#### Quote Tag

Quote tags are similar to standard tags, with the exception that *no trimming* is performed, and leading/trailing whitespace is preserved, ie:

```
Hello <%" $NAME "%>
```

Is equivalent to :

```
printf "%b%s\n" 'Hello ' " $NAME "  # Whitespace around $NAME is preserved
```

##### Default Delimiters

The default delimiters for Quote Tags are `<%"` &amp; `"%>`

More specifically, the delimiters are : Currently-configured Standard Tag delimiters with leading &amp; trailing quotes (`"`)

NOTE: No whitespace is allowed between the standard tag and the quote character (i.e. `<% "` would **not** be treated as a quote tag).

##### Example

_hello.tpl_
```
Hello '<%" <% $NAME %> "%>'
```

```
$ NAME=TekWizely source <( bash-tpl hello.tpl )

Hello ' <% TekWizely %> '
```

#### Statement Tag

Statement tags allow you to inline script statements, printing the output of the statement:

```
Hello <%% echo $NAME %>
```

Is equivalent to :

```
printf "%b%s\n" 'Hello ' "$(echo $NAME)"  # Trivial example to demonstrate the conversion
```

##### Better Example

A *slightly* more useful example of a statement tag might be:

_hello.tpl_
```
Hello <%% echo $NAME | tr '[:lower:]' '[:upper:]' %>
```

```
$ NAME=TekWizely source <( bash-tpl hello.tpl )

Hello TEKWIZELY
```

##### Default Delimiters

The default delimiters for Statement Tags are `<%%` &amp; `%>`

More specifically, the delimiters are : Currently-configured Standard Tag delimiters with the open delimiter followed by the Statement Tag delimiter.

**NOTES:**
* The statement Tag delimiter (ie the 2nd `%`) can be configured separate from the Standard Tag delimiters. See [Customizing Delimiters](#customizing-delimiters) for details.
* No whitespace is allowed between the Standard Tag and the Statement Tag delimiter (i.e. `<% %` would **not** be treated as a Statement Tag).
* The Statement Tag delimiter is *not* part of the close tag (`%>`), **just** the open tag (`<%%`)

##### Trimming

**NOTE:** As with Standard Tags, the value within the statement Tag is 'trimmed' before being processed, ie: `'<%% echo $NAME %>'` is equivalent to `'<%%echo $NAME%>'`.

### Formatting Text Tags

By default, all Text Tags are rendered with the _printf_ `%s` format specifier.

You can use a custom format specifier in your tags:

_integer_format.tpl_
```
% myint=123
<%|%d| $myint %>
```

_process the template_
```
$ bash-tpl integer_format.tpl

myint=123
printf "%d\n" "$myint"
```

#### % is Optional

The `%` in the format specifier is optional:

_integer_format.tpl_
```
% myint=123
<%|d| $myint %>
```

_process the template_
```
$ bash-tpl integer_format.tpl

myint=123
printf "%d\n" "$myint"
```

#### Default Delimiters

The default delimiters for the format specifier are `|` &amp; `|`

You can customize the delimiters:

_customized_format_delimiters.tpl_
```
.DELIMS tag-fmt="[ ]"
% myint=123
<%[%d] $myint %>
```

_process the template_
```
$ bash-tpl customized_format_delimiters.tpl

myint=123
printf "%d\n" "$myint"
```

See the [Customizing Delimiters](#customizing-delimiters) section to learn about the many ways you can customize delimiters to your liking.

-------------------
### Statement Lines

Statement lines allow you to easily insert a single line of script into your template:

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

--------------------
### Statement Blocks

Statement blocks allow you to add a full script block into your template:

```
%
    if [ -z "${1}" ]; then
        echo "Error: Missing argument" >&2
        return
    fi
%
Hello <% $1 %>
```

**NOTE:** Statement Block delimiters must be on their own line with no other non-whitespace characters.

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

##### Default Delimiter

The default start &amp; stop delimiter for Statement Blocks is `%`

More specifically, the default is : Currently-configured Statement Line delimiter.

#### Printing Text Within a Statement Block

Sometimes parts (or all) of your template may consist of complex code that just needs to print a small amount of text.

You could close and re-open your statement blocks, but that might feel verbose depending on the situation:

_verbose.tpl_
```
%
    # ...
    if (condition); then
%
condition text ...
%
    else
%
else text ...
%
    fi
    # ...
%
```

Bash-tpl allows you to print single lines of text within your statement blocks:

_inline.tpl_
```
%
    # ...
    if (condition); then
        % condition text ...
    else
        % else text ...
    fi
    # ...
%
```

**NOTES:**
* The indentation of the printed text lines will always match that of the statement block start tag
* This is to encourage you to format your text lines within the context of your script
* All whitespace _after_ the text line tag (`'% `') will be printed as-as

##### Similar Script Output

The two techniques generate nearly-identical scripts, but the inline script is slightly easier to read:

_verbose.sh_
```bash
# ...
if (condition); then
printf "%b\n" 'condition text ...'
else
printf "%b\n" 'else text ...'
fi
# ...
```

_inline.sh_
```bash
# ...
if (condition); then
    printf "%b\n" 'condition text ...'
else
    printf "%b\n" 'else text ...'
fi
# ...
```

##### Default Delimiter

The default delimiter for a Statement Block Text Line  is `'% '` (note the trailing space `' '`)

More specifically, the default is : Currently-configured Statement Line delimiter, followed by a space (`' '`)

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
printf "%b\n" 'Hello world'
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

**Support for potentially-missing files**

You can safely attempt to include a potentially-missing file using `.INCLUDE?`

_no errors if include file is missing_
```
.INCLUDE? optional-file.tpl
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
* The changes take effect immediately (i.e. the very next line)
* The changes are passed along to any included templates

The DELIMS directive accepts the following parameters:

| PARAM                | FORMAT     | NOTE                                                          |
|----------------------|------------|---------------------------------------------------------------|
| TAG                  | `".. .."`  | 2 two-char sequences, separated by a **single** space         |
| TAG-STMT             | `"."`      | 1 single character                                            |
| TAG-FMT              | `". ."`    | 2 single characters, separated by a **single** space          |
| STMT                 | `".+"`     | 1 or more characters                                          |
| STMT-BLOCK           | `".+ .+"`  | 2 one-or-more char sequences, separated by a **single** space |
| TXT &#124; TEXT      | `".+[ ]?"` | 1 or more characters, with an optional trailing space         |
| DIR &#124; DIRECTIVE | `".+"`     | 1 or more characters                                          |
| CMT &#124; COMMENT   | `".+"`     | 1 or more characters                                          |


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

| VARIABLE                   | FORMAT     | NOTE                                                          |
|----------------------------|------------|---------------------------------------------------------------|
| BASH_TPL_TAG_DELIMS        | `".. .."`  | 2 two-char sequences, separated by a **single** space         |
| BASH_TPL_TAG_STMT_DELIM    | `"."`      | 1 single character                                            |
| BASH_TPL_TAG_FMT_DELIMS    | `". ."`    | 2 single characters, separated by a **single** space          |
| BASH_TPL_STMT_DELIM        | `".+"`     | 1 or more characters                                          |
| BASH_TPL_STMT_BLOCK_DELIMS | `".+ .+"`  | 1 one-or-more char sequences, separated by a **single** space |
| BASH_TPL_TEXT_DELIM        | `".+[ ]?"` | 1 or more characters, with an optional trailing space         |
| BASH_TPL_DIR_DELIM         | `".+"`     | 1 or more characters                                          |
| BASH_TPL_CMT_DELIM         | `".+"`     | 1 or more characters                                          |

##### quick example

_test.tpl_
```
%# customize standard tag delimiter
Hello, {{ $1 }}
```

```
$ BASH_TPL_TAG_DELIMS="{{ }}" bash-tpl test.tpl > test.sh
$ . test.sh TekWizely

Hello, TekWizely
```

#### Command Line Options

The following command line options are available for customizing delimiters:

| OPTION                               | FORMAT     | NOTE                                                          |
|--------------------------------------|------------|---------------------------------------------------------------|
| --tag-delims                         | `".. .."`  | 2 two-char sequences, separated by a **single** space         |
| --tag-stmt-delim                     | `"."`      | 1 single character                                            |
| --tag-fmt-delims                     | `". ."`    | 2 single characters, separated by a **single** space          |
| --stmt-delim                         | `".+"`     | 1 or more characters                                          |
| --stmt-block-delims                  | `".+ .+"`  | 2 one-or-more char sequences, separated by a **single** space |
| --txt-delim &#124; --text-delim      | `".+[ ]?"` | 1 or more characters, with an optional trailing space         |
| --dir-delim &#124; --directive-delim | `".+"`     | 1 or more characters                                          |
| --cmt-delim &#124; --comment-delim   | `".+"`     | 1 or more characters                                          |

**NOTE:** Command-line options override environment variables.

##### quick example

_test.tpl_
```
%# customize standard tag delimiter
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
* Overrides any commend-line options that appear *before* the `--reset-delims` option
* Does **not** override any command-line options that appear *after* the `--reset-delims` option
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
## Similar Tools

Here's a list of some similar tools I discovered before deciding to create bash-tpl :
* [mo - mustache templates in bash](https://github.com/tests-always-included/mo)
* [esh - embedded shell (written in sh)](https://github.com/jirutka/esh)
* [envsubst (part of gnu gettext)](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)
* [shtpl (written in bash)](https://github.com/mlorenzo-stratio/shtpl)
* [shtpl (written in vala)](https://github.com/dontsueme/shtpl)
* [cookie (written in bash)](https://github.com/bbugyi200/cookie)
* [bash-templater](https://github.com/vicentebolea/bash-templater)
* [renderest (written in bash)](https://github.com/relaxdiego/renderest)
* [rc template language](https://werc.cat-v.org/docs/rc-template-lang)
* [pp shell-based pre-processor](https://adi.onl/pp.html)

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

If you want to contact me you can reach me at TekWizely@gmail.com.

----------
## License

The `tekwizely/bash-tpl` project is released under the [MIT](https://opensource.org/licenses/MIT) License.  See `LICENSE` file.

##### Adding `bash-tpl` into your project

The `bash-tpl` script has an embedded MIT [SPDX](https://spdx.org/licenses/MIT.html) header, as well as a license header, and should be safe for you to extract and add to your own projects for easy template generation.
