# `bin/zunit` is not in git, the release archive carries it

`bin/zunit` is built from `src/`. When it was committed, each build changed a tracked file, and the release checks needed a special filter (`grep -v " M bin/zunit$"`) to allow that one change. We stopped committing it. The Package step adds the built file to the release archive with `git archive --add-file`, and the Homebrew formula installs from the release archive URL and its `sha256`, not from the git tag. A git tag therefore does not contain `bin/zunit`. If you clone the repo, run `./configure && make build` first.
