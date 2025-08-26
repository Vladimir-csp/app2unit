APP2UNIT(1)
; scdoc manpage, build and compress:
; scdoc < app2unit.1.scd | gzip -c > app2unit.1.gz

# NAME

*app2unit*, *app2unit-open*, *app2unit-term*, *app2unit-open-scope*,
*app2unit-open-service*, *app2unit-term-scope*, *app2unit-term-service*

Application launcher, file opener, default terminal launcher
for systemd environments.

# SYNOPSIS

*app2unit* [_options_] [--] {_entry-id.desktop_ |
_entry-id.desktop_:_action-id_ | _command_} [_args_ ...]

*app2unit* -T [_options_] [--] [_entry-id.desktop_ |
_entry-id.desktop_:_action-id_ | _command_] [_args_ ...]

*app2unit* -O [_options_] [--] {_URL_|_Path_ ...}

# DESCRIPTION

*app2unit* launches applications by their Desktop Entry IDs, or arbitrary
command lines. Applications are launched as systemd user units.

With *-O* option it can open files or URLs in associated applications.

With *-T* option it can force running application in a terminal, or just open
default terminal (utilizing *xdg-terminal-exec*).

Symlinks with specially suffixed names can be used to pre-select some modes and
unit types with single command:

- *app2unit-open*
- *app2unit-open-scope*
- *app2unit-open-service*
- *app2unit-term*
- *app2unit-term-scope*
- *app2unit-term-service*

# OPTIONS

*-s* {*a*|*b*|*s*|_custom.slice_}

	Select slice among short references (the first one is the default):++
	"*a=app.slice b=background.slice s=session.slice*"++
Or set slice explicitly. Default and short
	references can be preset via *APP2UNIT_SLICES* env var in the format
	above.

*-t* {*scope*|*service*}

	Type of unit to launch. Can be preselected via *APP2UNIT_TYPE* env var
	and if _$0_ ends with "*-scope*" or "*-service*".

*-a* _app_name_

	Override substring of Unit ID representing application name.
	Defaults to Entry ID without extension, or executable name.
	Conflicts with *-u*.

*-u* _unit_id_

	Override the whole Unit ID. Must match type. Defaults to recommended
	templates:
		app-_${desktop}_-_${app_name}_@_${random}_.service++
app-_${desktop}_-_${app_name}_-_${random}_.scope
	Conflicts with *-a*.

*-d* _description_

	Set/override unit description. By default description is generated from
	Entry's "*Name=*" and "*GenericName=*" keys.

*-p* _Property_=_value_

	Set additional unit property (option is repeatable).

*-T*

	Force launch in terminal (*xdg-terminal-exec* is used). Any unknown
	option starting with '-' after this will be passed to
	*xdg-terminal-exec*. Command may be omitted to just launch default
	terminal. This mode can also be selected if _$0_ ends with "*-term*" or
	"*-terminal*", also optionally followed by "*-scope*" or "*-service*"
	unit type suffixes.

*-S* {*out*|*err*|*both*}

	Silence stdout, stderr, or both.

*-c*

	Do not add *graphical-session.target* dependency and ordering.
	Also can be preset with env var "*APP2UNIT_PART_OF_GST=false*".

*-C*

	Add *graphical-session.target* dependency and ordering (default
	behavior).

*-O*, *--open*

	Opener mode: argument(s) are treated as file(s) or URL(s) to open.
	Desktop Entry for them is found via *xdg-mime*. Only single association
	is supported.
	This mode can also be selected if _$0_ ends with "*-open*", also
	optionally followed by "*-scope*" or "*-service*" unit type suffixes.

*--fuzzel-compat*

	For using in *fuzzel* like this:

		fuzzel --launch-prefix='app2unit --fuzzel-compat --'

	Will need updates after this is solved:
	https://codeberg.org/dnkl/fuzzel/issues/292

*--test*

	Do not run anything, print resulting command.

*--*

	Disambiguate command from options.

# ENVIRONMENT

*APP2UNIT_TYPE*

	*scope*|*service*, presets default unit type (default: *scope*).

*APP2UNIT_SLICES*

	Assignments of short selectors to slice names. The first assignment is
	the default slice for apps (default: "*a=app.slice b=background.slice
	s=session.slice*").

*APP2UNIT_PART_OF_GST*

	*true*|*false*, whether to set "*PartOf=graphical-session.target*"
	dependency for launched applications (default: *true*)

# SEE ALSO

*systemd-run*(1), *systemd.special*(7), *xdg-terminal-exec*(1)

# AUTHORS

Vladimir-csp (https://github.com/Vladimir-csp, https://gitlab.freedesktop.org/Vladimir-csp)
