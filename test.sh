#!/usr/bin/env bash
set -o errexit # Abort if any command fails
me=$(basename "$0")

help_message="\
Usage:
  $me --test <test>
  $me --help
Arguments:
  -t, --test <test>             The string to test.
  -h, --help                    Displays this help screen.
  -v, --verbose                 Increase verbosity. Useful for debugging."

parse_args() {
    while : ; do
        if [[ $1 = "-h" || $1 = "--help" ]]; then
            echo "$help_message"
            return 0
        elif [[ $1 = "-v" || $1 = "--verbose" ]]; then
            verbose=true
            shift
        elif [[ $1 = "-t" || $1 = "--test" ]]; then
            test=${2// }

            if [[ "$test" = "--"* ]]; then
                test=""
                shift 1
            else
                shift 2
            fi
        else
            break
        fi
    done

    if [[ -z "$test" ]]; then
        echo "Missing required argument: --test <test>."
        echo "$help_message"
        return 1
    fi
}

# Echo expanded commands as they are executed (for debugging)
enable_expanded_output() {
    if [ $verbose ]; then
        set -o xtrace
        set +o verbose
    fi
}

main() {
    parse_args "$@"
    echo "Test: '$test'."
}

main "$@"
