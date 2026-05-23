 ### 1. Create 8 fixed workspaces

 ```bash
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 8
 ```

## Switch to Workspace n
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Control><Shift>h']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Control><Shift>j']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Control><Shift>k']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Control><Shift>l']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Control><Shift>semicolon']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Control><Shift>b']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Control><Shift>n']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Control><Shift>m']"

## Move Current Window to Workspace n
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Control><Shift><Alt>h']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Control><Shift><Alt>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Control><Shift><Alt>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Control><Shift><Alt>l']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Control><Shift><Alt>semicolon']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Control><Shift><Alt>b']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Control><Shift><Alt>n']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Control><Shift><Alt>m']"
