# App2Unit

Launch Desktop Entries (or arbitrary commands) as Systemd user units, and do it
fast.

Based heavily on mechanisms and optimizations introduced into
[xdg-terminal-exec](https://github.com/Vladimir-csp/xdg-terminal-exec) by @fluvf, it performs function
similar to (and behaves similarly to) [uwsm](https://github.com/Vladimir-csp/uwsm)'s `app` subcommand, but
without the costly startup of Python interpreter or the necessity of having a daemon
running for speeding things up. If run on a fast shell (such as `dash`) with
system stored on an SSD, overhead can be as short as ~0.03s, with `systemd-run`
giving additional ~0.03s.

## Syntax

    app2unit \
      [-h | --help]
      [-s a|b|s|custom.slice] \
      [-t scope|service] \
      [-a app_name | -u unit_id] \
      [-d description] \
      [-S out|err|both] \
      [-T] \
      [-O | --open] \
      [-c|-C] \
      [--fuzzel-compat] \
      [--test]
      [--] \
      {entry-id.desktop | entry-id.desktop:action-id | command} \
      [args ...]

See `--help` for more info.

## UWSM integration

Transparently, via having environment variables in your sessions:

To use UWSM's custom slices:

    APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'

To change default unit type:

    APP2UNIT_TYPE=service

## Fuzzel integration

Can be integrated into [Fuzzel](https://codeberg.org/dnkl/fuzzel/) launcher via
its launch prefix feature: `--launch-prefix='app2unit --fuzzel-compat --'`.
app2unit will use command line provided by Fuzzel as is, but currently it will
have to re-find and re-parse desktop entry to extract metadata since Fuzzel [can
only tell it Desktop Entry ID and nothing
more](https://codeberg.org/dnkl/fuzzel/issues/292).

## Terminal support

Requires `xdg-terminal-exec`. When the terminal is requested explicitly (with `-T`
argument or `*-term` executable link), any unknown option starting with `-`
after `-T` and before `--` (or a command) are passed to `xdg-terminal-exec` to
be handled according to the
[Default Terminal Spec proposal](https://gitlab.freedesktop.org/terminal-wg/specifications/-/merge_requests/3).

### Launching default terminal

`app2unit -T` or `app2unit-term` (without command) can be used to open the default
terminal as a unit, with unit metadata filled from its desktop entry.

Proper metadata support requires scripting options in `xdg-terminal-exec`
available since version 0.13.0.

## Opener mode

If invoked with `-O | --open` option, or if the executable's name ends with
`-open` (i.e. via `app2unit-open` symlink), the script becomes an analog of
`xdg-open`: files or URLs given in arguments are opened with a desktop entry
automatically selected via `xdg-mime`. This can be a unit-aware drop-in
replacement for `xdg-open`.

### Opening default file manager

Assuming it is an association for `inode/directory`:

```
app2unit-open .
```

## Single-command links

Links are available to pre-select some launching modes via a single command:

* `app2unit-open`
* `app2unit-open-scope`
* `app2unit-open-service`
* `app2unit-term`
* `app2unit-term-scope`
* `app2unit-term-service`

This may come in handy for situations where other apps can only operate a command
without arguments. I.e., selecting a terminal command in PCmanFM.
