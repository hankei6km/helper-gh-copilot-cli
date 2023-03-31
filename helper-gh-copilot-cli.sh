# Helper function GitHub Copilot for CLI

function __helper_github_copilot_cli__ {
  local SAVE_FILE KIND QUERY OUTPUT

  SAVE_FILE="$(mktemp)"
  trap 'test -f "${SAVE_FILE}" && rm "${SAVE_FILE}"' RETURN

  KIND="$( echo "${READLINE_LINE}" | cut -f 1 -d " " )"
  if test -z "{KIND}"; then
    return
  fi

  QUERY="$( echo "${READLINE_LINE}" | cut -f 2- -d " " )"
  case "${KIND}" in
    "??")
      github-copilot-cli what-the-shell --shellout "${SAVE_FILE}" "${QUERY}"
    ;;
    "git?")
      github-copilot-cli git-assist --shellout "${SAVE_FILE}"  "${QUERY}"
    ;;
    "gh?")
      github-copilot-cli gh-assist --shellout "${SAVE_FILE}"  "${QUERY}"
    ;;
  esac
  if test "${?}" -eq 0 ; then
    OUTPUT="$(cat "${SAVE_FILE}")"
    shellcheck <(echo -e "#!/bin/bash\n${OUTPUT}") 
    # replace the line with the output always.
    READLINE_LINE="${OUTPUT}"
    READLINE_POINT=0x7fffffff
  fi
}

# 
bind -m emacs-standard -x '"\C-a":__helper_github_copilot_cli__'
bind -m vi-command -x '"\C-a":__helper_github_copilot_cli__'
bind -m vi-insert -x '"\C-a":__helper_github_copilot_cli__'