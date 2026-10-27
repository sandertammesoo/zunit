# Shared helpers for the tasks in .mise/tasks/release. Each task sources this file.
# The words Release, Release check, Publish, Package and Formula update are defined in GLOSSARY.md.

setopt err_exit pipe_fail no_unset

cd "${MISE_PROJECT_ROOT:-${0:A:h}/../..}"

readonly REPO=sandertammesoo/zunit
readonly TAP=sandertammesoo/formulae
readonly DIST=dist

die() {
	print -u2 -- "error: $*"
	exit 1
}

say() {
	print -- "==> $*"
}

# need <command>...: stop if a command is missing, and name the Homebrew package that has it.
need() {
	local -A package=(gpg gnupg)
	local cmd
	for cmd in "$@"; do
		(( $+commands[$cmd] )) || die "$cmd not found. Run: brew install ${package[$cmd]:-$cmd}"
	done
}

# The version in VERSION, as x.y.z.
release_version() {
	local version
	read -r version < VERSION
	[[ $version == <->.<->.<-> ]] || die "VERSION has '$version', not x.y.z"
	print -r -- $version
}

on_branch() {
	[[ $(git branch --show-current) == $1 ]] || die "you are not on $1. Run: git switch $1"
}

clean_tree() {
	[[ -z $(git status --porcelain) ]] || die "the working tree has changes. Commit or stash them first:
$(git status --short)"
}

local_tag_exists() {
	git rev-parse -q --verify "refs/tags/$1" >/dev/null
}

remote_tag_exists() {
	git ls-remote --exit-code --tags origin "refs/tags/$1" >/dev/null
}

# confirm <question>: continue only if the user types yes.
confirm() {
	local answer
	read -r "answer?$1 Type 'yes' to continue: "
	[[ $answer == yes ]] || die "stopped. Nothing changed after this point."
}
