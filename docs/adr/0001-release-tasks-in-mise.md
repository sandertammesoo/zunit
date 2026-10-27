# Release tasks use mise, build and install stay in make

The release targets were about 470 lines of shell inside `Makefile.in`, with `$$` escapes and a `\` at the end of each line, and `make` gave them nothing because all of them were `.PHONY`. We moved them to zsh file tasks in `.mise/tasks/release/`. We kept `build`, `test`, `install`, `uninstall`, and `clean` in `make`, because `./configure && make install` is the contract for users and package managers, and they must not need mise. Only the maintainer runs a Release, so only the maintainer needs mise.
