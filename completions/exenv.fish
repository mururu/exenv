function __fish_exenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'exenv' ]
    return 0
  end
  return 1
end

function __fish_exenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

complete -f -c exenv -n '__fish_exenv_needs_command' -a '(exenv commands)'
for cmd in (exenv commands)
  complete -f -c exenv -n "__fish_exenv_using_command $cmd" -a "(exenv completions $cmd)"
end
