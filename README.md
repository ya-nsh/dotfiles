# dotfiles

Personal config files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```bash
git clone git@github.com:ya-nsh/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh git nvim tmux
```

## Structure

| Package | Config |
|---------|--------|
| `zsh`   | `~/.zshrc` |
| `git`   | `~/.gitconfig` |
| `nvim`  | `~/.config/nvim/` |
| `tmux`  | `~/.tmux.conf` |

---

## tmux

### First-time setup

```bash
# 1. Install tpm (plugin manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 2. Symlink config via stow
stow tmux

# 3. Start tmux then install plugins
tmux
# inside tmux:  Ctrl+b  then  I  (capital i)
```

### The Ctrl+b logic

Every tmux command starts with the **prefix key**: `Ctrl+b`.  
Press it, release, then press the action key.

| Keys | What it does |
|------|--------------|
| `Ctrl+b d` | Detach from session (session stays running) |
| `Ctrl+b s` | List and switch sessions |
| `Ctrl+b $` | Rename current session |
| `Ctrl+b c` | New window |
| `Ctrl+b ,` | Rename window |
| `Ctrl+b n / p` | Next / previous window |
| `Ctrl+b 1..9` | Jump to window by number |
| `Ctrl+b \|` | Split pane vertically *(custom)* |
| `Ctrl+b -` | Split pane horizontally *(custom)* |
| `Ctrl+b h/j/k/l` | Navigate panes (vim-style) *(custom)* |
| `Ctrl+b H/J/K/L` | Resize panes *(custom)* |
| `Ctrl+b r` | Reload config *(custom)* |
| `Ctrl+b [` | Enter scroll/copy mode (use vim keys, `q` to exit) |
| `Ctrl+b z` | Zoom current pane (toggle fullscreen) |
| `Ctrl+b x` | Kill current pane |
| `Ctrl+b &` | Kill current window |

### Plugins

| Plugin | What it does |
|--------|--------------|
| **tpm** | Plugin manager — installs and updates all other plugins |
| **tmux-sensible** | Sane defaults everyone agrees on (UTF-8, faster repeat, etc.) |
| **tmux-resurrect** | Manually save (`Ctrl+b Ctrl+s`) and restore (`Ctrl+b Ctrl+r`) sessions, including open panes, windows, and running programs |
| **tmux-continuum** | Builds on resurrect — auto-saves every 15 min and auto-restores on `tmux` start so sessions survive reboots |

#### Plugin key bindings

| Keys | Plugin | Action |
|------|--------|--------|
| `Ctrl+b I` | tpm | Install plugins listed in config |
| `Ctrl+b U` | tpm | Update all plugins |
| `Ctrl+b Alt+u` | tpm | Remove plugins not in config |
| `Ctrl+b Ctrl+s` | tmux-resurrect | Save session now |
| `Ctrl+b Ctrl+r` | tmux-resurrect | Restore last saved session |

#### Session restore after reboot

Just run `tmux` — continuum auto-restores your last saved state.  
No extra steps needed once the plugin is installed.
