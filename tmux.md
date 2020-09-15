# TMUX

connect to VPN 
connect to the host
On the command prompt, type tmux new-session -s my_session,  <== ON THE HOST
Run the desired program.
Use the key sequence Ctrl-b + d to detach from the session.
Reattach to the Tmux session by typing tmux attach-session -t my_session (edited)

also when you first re-connect to the host you can run tmux ls which will show you the active sessions which you can then re-conect to


Keystroke bindings
^B [Enter scroll/copy modeESCExit scroll/copy mode
^B c Create new window
^B d detach
^B 3 goto window 3
^B ? Show all keystroke bindings

bash commands
tmux new-session -s my_session
tmux attach-session -t my_session
tmux rename-window -t ${TMUX_PANE} "git lfs clone"
tmux set-window-option -g automatic-rename off


