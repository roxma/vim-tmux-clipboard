
# vim-tmux-clipboard

Things get messy when I need to copy lines of text from vim into tmux's
clipboard, especially when multiple split-windows are opened. So I created this
super simple plugin, which provides seamless integration for vim and tmux's
clipboard.


vim-tmux-clipboard automatically copy yanked text into tmux's clipboard, and
copy tmux's clipboard content into vim's quote(`"`) register, known as the unnamed
register. It also makes multiple vim processes on top of the same tmux session
act like they're sharing the same clipboard.


## Requirements

- add `set -g focus-events on` to your `tmux.conf`.
- [vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events) for vim users.
- [neovim](https://github.com/neovim/neovim) or vim above 8.0.1394 is
  recommended for `TextYankPost` event, which is required for `It also makes
  multiple vim processes on top of the same tmux session act like they're
  sharing the same clipboard`.


## Demo

[![asciicast](https://asciinema.org/a/7qzb7c12ykv3kcleo4jgrl2jy.png)](https://asciinema.org/a/7qzb7c12ykv3kcleo4jgrl2jy)


