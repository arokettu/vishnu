# Changelog

## 2.0.0

Mostly refactoring
- use `url` method as primary way to get avatar url instead of `to_s`
- make all methods except for `url`, `to_s` and attribute setters and getters private
- bump minimum ruby version to 2.0.0
- change build system from jeweler to bundler
- change test system from shoulda to rspec
- add travis builds for all minor ruby versions

## 1.2.2

Merged development dependencies from upstream

## 1.2.1

bugfix release for libravatar 1.2.0
- fix weighted random on federated avatars
- fix crash on custom ports on federated avatars

UPD: contains all fixes from libravatar 1.3.0
