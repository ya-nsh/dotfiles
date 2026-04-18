# tmux Cheatsheet

Prefix key: `Ctrl+a` (press and release, then press the action key)

---

## Sessions

| Command | Action |
|---------|--------|
| `tmux new -s <name>` | Create new named session |
| `tmux attach -t <name>` | Attach to session by name |
| `tmux attach` | Attach to last session |
| `tmux ls` | List all sessions |
| `tmux kill-session -t <name>` | Kill a session |
| `tmux kill-server` | Kill all sessions |
| `Ctrl+a d` | Detach (session stays alive) |
| `Ctrl+a s` | Visual session picker |
| `Ctrl+a $` | Rename current session |

---

## Windows (tabs)

| Keys | Action |
|------|--------|
| `Ctrl+a c` | New window |
| `Ctrl+a ,` | Rename window |
| `Ctrl+a n` | Next window |
| `Ctrl+a p` | Previous window |
| `Ctrl+a 1–9` | Jump to window by number |
| `Ctrl+a &` | Kill current window |

---

## Panes (splits)

| Keys | Action |
|------|--------|
| `Ctrl+a \|` | Split vertically |
| `Ctrl+a -` | Split horizontally |
| `Ctrl+a h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+a H/J/K/L` | Resize pane |
| `Ctrl+a z` | Zoom pane (toggle fullscreen) |
| `Ctrl+a x` | Kill current pane |

---

## Copy mode

| Keys | Action |
|------|--------|
| `Ctrl+a [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Yank/copy and exit |
| `Ctrl+a ]` | Paste |
| `q` | Exit copy mode |
| `Shift + mouse select` | Copy with system clipboard |

---

## Plugins (tpm)

| Keys | Action |
|------|--------|
| `Ctrl+a I` | Install plugins |
| `Ctrl+a U` | Update plugins |
| `Ctrl+a Alt+u` | Remove unused plugins |

---

## Session persistence (tmux-resurrect + tmux-continuum)

| Keys / Command | Action |
|----------------|--------|
| `Ctrl+a Ctrl+s` | Save session to disk now |
| `Ctrl+a Ctrl+r` | Restore session from disk |
| `tmux` | Auto-restores last saved state on boot |

### Save vs Restore vs Detach vs Attach

| | Session alive in memory? | Survives reboot? |
|---|---|---|
| **Detach** (`Ctrl+a d`) | Yes | No |
| **Attach** (`tmux attach`) | Was already alive | — |
| **Save** (`Ctrl+a Ctrl+s`) | Yes | Yes — written to disk |
| **Restore** (`Ctrl+a Ctrl+r`) | Reconstructed from disk | — |

- **Detach/attach**: session never died, just backgrounded. Like minimizing an app.
- **Save/restore**: session layout written to `~/.tmux/resurrect/`. After a reboot, restore reconstructs panes, windows, and commands from that snapshot.

---

## Misc

| Keys / Command | Action |
|----------------|--------|
| `Ctrl+a r` | Reload config |
| `Ctrl+a [` then `/ <term>` | Search in scroll history |
| `tmux new -s <name> -d` | Create session in background |
