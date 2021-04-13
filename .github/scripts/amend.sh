#!/bin/bash
set -o errexit # Abort if any command fails
me=$(basename "$0")

help_message="\
Usage: echo $me

Checks out the pull request where an '/amend' comment is made and amends its
latest commit with the credentials of the user who wrote the '/amend' comment.

GITHUB_CONTEXT: An environment variable containing a JSON string of the GitHub
                context object. Typically generated with \${{ toJson(github) }}."

initialize() {
    github_context_json="$GITHUB_CONTEXT"

    if [[ -z "$github_context_json" ]]; then
        echo "Missing or empty GITHUB_CONTEXT environment variable." >&2
        echo "$help_message"
        exit 1
    fi

    pr_url=$(echo "$github_context_json" | jq --raw-output .event.issue.pull_request.html_url)
    username=$(echo "$github_context_json" | jq --raw-output .actor)

    if [[ -z "$pr_url" ]]; then
        echo "No 'pr_url' found in the GitHub context." >&2
        echo "$help_message"
        exit 1
    fi

    if [[ -z "$username" ]]; then
        echo "No 'username' found in the GitHub context." >&2
        echo "$help_message"
        exit 1
    fi

    user_url="users/$username"
    user_json=$(gh api -X GET "$user_url")

    if [[ -z "$user_json" ]]; then
        echo "The request for '$user_url' failed." >&2
        echo "$help_message"
        exit 1
    fi

    name=$(echo $user_json | jq --raw-output .name)
    email=$(echo $user_json | jq --raw-output .email)

    if [[ -z "$name" ]]; then
        echo "No 'name' found in '$user_url'." >&2
        echo "$help_message"
        exit 1
    fi

    if [[ -z "$email" ]]; then
        echo "No 'email' found in '$user_url'." >&2
        echo "$help_message"
        exit 1
    fi
}

amend() {
    gh pr checkout "$pr_url"
    git config --global user.name "$name"
    git config --global user.email "$email"
    git commit --amend --no-edit
    git push --force
}

main() {
    initialize "$@"
    amend
}

main "$@"
