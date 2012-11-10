if [[ ! -o interactive ]]; then
    return
fi

compctl -K _exenv exenv

_exenv() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(exenv commands)"
  else
    completions="$(exenv completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
