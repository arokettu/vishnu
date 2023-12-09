# Changelog

## 2.x

### 2.0.1

*Dec 9, 2023*

* Re-release 2.0.0 with updated homepage and email

### 2.0.0

*26 Mar, 2016*

Forked from 1.2.0 of the Libravatar gem

Mostly refactoring
- use `url` method as primary way to get avatar url instead of `to_s`
- make all methods except for `url`, `to_s` and attribute setters and getters private
- bump minimum ruby version to 2.0.0
- change build system from jeweler to bundler
- change test system from shoulda to rspec
- add travis builds for all minor ruby versions

## 1.x

### 1.2.2

*20 Jun, 2016*

Merged development dependencies from upstream

### 1.2.1

*25 Mar, 2016*

bugfix release for libravatar 1.2.0
- fix weighted random on federated avatars
- fix crash on custom ports on federated avatars

UPD: contains all fixes from libravatar 1.3.0
