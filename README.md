# App2Unit

Launch Desktop Entries (or arbitrary commands) as Systemd user units, and do it
fast.

Based heavily on mechanisms and optimizations introduced into
[xdg-terminal-exec](../xdg-terminal-exec/) by @fluvf, it performs function
similar to (and behaves similarly to) [uwsm](../uwsm)'s `app` subcommand, but
without costly startup of python interpreter or necessity of having a daemon
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
      [--fuzzel-compat] \
      [--test]
      [--] \
      {entry-id.desktop | entry-id.desktop:action-id | command} \
      [args ...]

See `--help` for more info.

## Fuzzel integration

Can be integrated into [Fuzzel](https://codeberg.org/dnkl/fuzzel/) launcher via
its launch prefix feature: `--launch-prefix='app2unit --fuzzel-compat --'`.
app2unit will use command line provided by Fuzzel as is, but currently it will
have to re-find and re-parse desktop entry to extract metadata since Fuzzel [can
only tell it Desktop Entry ID and nothing
more](https://codeberg.org/dnkl/fuzzel/issues/292).

## UWSM integration

Transparently, via having environment variables in your sessions:

To use UWSM's custom slices:

    APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'

To change default unit type:

    APP2UNIT_TYPE=service
