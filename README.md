
# vim-tmux-clipboard

This plugin provides seemless integration for vim and tmux's clipboard.
Automatically copy yanked text into tmux's clipboard, and copy tmux's clipboard
content into vim's quote(`"`) register, known as unnamed register.

## Requirements

- neovim. This is due to vim dosen't support the `TextYankPost` event.
- [tmux-plugins/vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events)

