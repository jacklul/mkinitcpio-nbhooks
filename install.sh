#!/bin/bash
#shellcheck disable=SC1091,SC2153

build ()
{
    local HOOKS WAIT TIMEOUT

    if [ -f /etc/default/nbhooks.conf ]; then
        source /etc/default/nbhooks.conf
    else
        error "Missing configuration file"
        return 1
    fi

    for HOOK in "${HOOKS[@]}"; do
        sed 's/run_hook\s*(\s*)/run_hook_actual()/g' -i "$BUILDROOT/hooks/$HOOK"

        cat <<EOF >> "$BUILDROOT/hooks/$HOOK"

run_hook()
{
    run_hook_actual &
    $([ "$WAIT" != true ] && echo '#')echo \$! > "/.pid-$HOOK"
}
EOF

        if [ "$WAIT" = true ]; then
            sed 's/run_cleanuphook\s*(\s*)/run_cleanuphook_actual()/g' -i "$BUILDROOT/hooks/$HOOK"
            cat <<EOF >> "$BUILDROOT/hooks/$HOOK"

run_cleanuphook()
{
    if [ -f "/.pid-$HOOK" ]; then
        PID=\$(cat "/.pid-$HOOK")
        TIMEOUT=$TIMEOUT
        while ps | grep -q "^\s*\$PID\s" && [ "\$TIMEOUT" -ge 0 ]; do
            echo "Waiting for \$PID to finish (\${TIMEOUT}s)..."
            TIMEOUT=\$((TIMEOUT-1))
            sleep 1
        done
        rm -f "/.pid-$HOOK"
    fi

    run_cleanuphook_actual
}
EOF
        fi
    done
}

help ()
{
    cat<<HELPEOF
This hook changes execution function of other hooks to run in a non-blocking way.
HELPEOF
}
