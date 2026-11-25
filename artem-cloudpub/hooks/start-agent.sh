#!/bin/sh
set -efu
umask 077

if [ -z "${TOKEN:-}" ] || [ -z "${HTTP:-}${HTTPS:-}" ]; then
    printf '%s\n' 'Set TOKEN and at least one HTTP or HTTPS address in Umbrel app settings.'
    exec sleep infinity
fi

/clo --log-level info set token "$TOKEN" >/dev/null
unset TOKEN

register_targets() (
    protocol=$1
    targets=$2
    IFS=,
    for target in $targets; do
        [ -n "$target" ] || continue
        /clo --log-level info register "$protocol" "$target"
    done
)

register_targets http "${HTTP:-}"
register_targets https "${HTTPS:-}"
exec /clo --log-level info run
