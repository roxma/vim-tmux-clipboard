
# vim-tmux-clipboard

Things get nasty when I need to copy lines of text from vim into tmux's
clipboard, especially when multiple split-windows are opened. So I created this
super simple plugin, which provides seemless integration for vim and tmux's
clipboard.


vim-tmux-clipboard automatically copy yanked text into tmux's clipboard, and
copy tmux's clipboard content into vim's quote(`"`) register, known as the unnamed
register. It also make multiple vim processes on top of the same tmux session
act like they're sharing the same clipboard.


## Requirements

- [neovim](https://github.com/neovim/neovim). This is due to vim dosen't
    support the `TextYankPost` event.
- [vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events)


## Demo

[![asciicast](https://asciinema.org/a/7qzb7c12ykv3kcleo4jgrl2jy.png)](https://asciinema.org/a/7qzb7c12ykv3kcleo4jgrl2jy)


