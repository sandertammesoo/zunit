# ZUnit

ZUnit is a unit test framework for zsh scripts. This glossary covers the words for how a ZUnit version gets to users.

## Releasing

**Release**:
The whole process that takes a new version from the version bump to the GitHub Release and the formula update.
_Avoid_: Full release, deploy

**Release check**:
The step of a Release that builds and tests the new version on `develop` before anything is tagged.
_Avoid_: Release (for this step alone), prepare

**Publish**:
The step of a Release that pushes the new version to GitHub. It is the first step that other people can see.
_Avoid_: Ship, deploy

**Package**:
The step of a Release that makes the release archive and its signature.
_Avoid_: Deploy, build

**Release archive**:
The `.tar.gz` file for one version, with its `.asc` signature.
_Avoid_: Tarball, bundle

**GitHub Release**:
The page on GitHub for one tag, which carries the release archive.
_Avoid_: Release (for this page alone)

**Formula update**:
The step of a Release that points the ZUnit formula in the `sandertammesoo/formulae` Homebrew tap at the new release archive.
_Avoid_: Homebrew release, tap bump
