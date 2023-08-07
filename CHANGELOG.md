# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v3.0.0](https://github.com/treydock/puppet-module-pcp/tree/v3.0.0) (2023-08-07)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/v2.1.0...v3.0.0)

### Changed

- Numerous updates - Drop Puppet 6, add Puppet 8 [\#28](https://github.com/treydock/puppet-module-pcp/pull/28) ([treydock](https://github.com/treydock))

### Added

- Support stdlib 9.x, update metadata to support EL9 [\#30](https://github.com/treydock/puppet-module-pcp/pull/30) ([treydock](https://github.com/treydock))
- Add EL9 support [\#29](https://github.com/treydock/puppet-module-pcp/pull/29) ([treydock](https://github.com/treydock))

## [v2.1.0](https://github.com/treydock/puppet-module-pcp/tree/v2.1.0) (2022-03-09)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/v2.0.0...v2.1.0)

### Added

- Add hooks for pmie and pmlogger resources. [\#26](https://github.com/treydock/puppet-module-pcp/pull/26) ([jcpunk](https://github.com/jcpunk))

## [v2.0.0](https://github.com/treydock/puppet-module-pcp/tree/v2.0.0) (2021-11-30)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/v1.8.0...v2.0.0)

### Changed

- Support RHEL8/Rocky8 [\#25](https://github.com/treydock/puppet-module-pcp/pull/25) ([treydock](https://github.com/treydock))
- Major updates, READ DESCRIPTION [\#24](https://github.com/treydock/puppet-module-pcp/pull/24) ([treydock](https://github.com/treydock))

## [v1.8.0](https://github.com/treydock/puppet-module-pcp/tree/v1.8.0) (2019-10-28)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/v1.7.0...v1.8.0)

### Added

- Increase stdlib supported versions [\#20](https://github.com/treydock/puppet-module-pcp/pull/20) ([treydock](https://github.com/treydock))
- Use module Hiera data [\#19](https://github.com/treydock/puppet-module-pcp/pull/19) ([treydock](https://github.com/treydock))
- Support managing /etc/pcp.conf [\#18](https://github.com/treydock/puppet-module-pcp/pull/18) ([treydock](https://github.com/treydock))

## [v1.7.0](https://github.com/treydock/puppet-module-pcp/tree/v1.7.0) (2019-07-11)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/v1.6.0...v1.7.0)

### Added

- Support excluding packages from PCP repos [\#17](https://github.com/treydock/puppet-module-pcp/pull/17) ([treydock](https://github.com/treydock))

## [v1.6.0](https://github.com/treydock/puppet-module-pcp/tree/v1.6.0) (2019-05-09)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/v1.5.0...v1.6.0)

### Added

- Simplify package removal when absent set [\#16](https://github.com/treydock/puppet-module-pcp/pull/16) ([treydock](https://github.com/treydock))

## [v1.5.0](https://github.com/treydock/puppet-module-pcp/tree/v1.5.0) (2019-05-08)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.4.3...v1.5.0)

### Added

- Use pdk [\#15](https://github.com/treydock/puppet-module-pcp/pull/15) ([treydock](https://github.com/treydock))

## [1.4.3](https://github.com/treydock/puppet-module-pcp/tree/1.4.3) (2019-05-08)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.4.2...1.4.3)

### Fixed

- Remove pcp-selinux when ensure is absent [\#14](https://github.com/treydock/puppet-module-pcp/pull/14) ([treydock](https://github.com/treydock))

## [1.4.2](https://github.com/treydock/puppet-module-pcp/tree/1.4.2) (2019-05-07)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.4.1...1.4.2)

### Fixed

- Remove repo when ensure is absent [\#13](https://github.com/treydock/puppet-module-pcp/pull/13) ([treydock](https://github.com/treydock))

## [1.4.1](https://github.com/treydock/puppet-module-pcp/tree/1.4.1) (2018-12-18)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.4.0...1.4.1)

### Fixed

- Fix removal of pmda config directory [\#12](https://github.com/treydock/puppet-module-pcp/pull/12) ([treydock](https://github.com/treydock))

## [1.4.0](https://github.com/treydock/puppet-module-pcp/tree/1.4.0) (2018-12-04)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.3.1...1.4.0)

### Added

- Support puppet 6 and drop puppet 4 [\#11](https://github.com/treydock/puppet-module-pcp/pull/11) ([treydock](https://github.com/treydock))
- Support setting pmda arguments [\#9](https://github.com/treydock/puppet-module-pcp/pull/9) ([treydock](https://github.com/treydock))
- Document with puppet-strings [\#8](https://github.com/treydock/puppet-module-pcp/pull/8) ([treydock](https://github.com/treydock))

### Fixed

- Use beaker 4.x [\#10](https://github.com/treydock/puppet-module-pcp/pull/10) ([treydock](https://github.com/treydock))

## [1.3.1](https://github.com/treydock/puppet-module-pcp/tree/1.3.1) (2018-06-29)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.3.0...1.3.1)

### Fixed

- Fix service start order for pmcd and pmlogger [\#7](https://github.com/treydock/puppet-module-pcp/pull/7) ([treydock](https://github.com/treydock))

## [1.3.0](https://github.com/treydock/puppet-module-pcp/tree/1.3.0) (2018-05-24)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.2.0...1.3.0)

### Added

- Quota pmlogger log directory path [\#6](https://github.com/treydock/puppet-module-pcp/pull/6) ([treydock](https://github.com/treydock))

## [1.2.0](https://github.com/treydock/puppet-module-pcp/tree/1.2.0) (2018-05-18)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.1.1...1.2.0)

### Added

- Add service\_ensure and service\_enable parameters. [\#5](https://github.com/treydock/puppet-module-pcp/pull/5) ([treydock](https://github.com/treydock))

## [1.1.1](https://github.com/treydock/puppet-module-pcp/tree/1.1.1) (2018-05-17)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.1.0...1.1.1)

### Added

- Update README [\#4](https://github.com/treydock/puppet-module-pcp/pull/4) ([treydock](https://github.com/treydock))

## [1.1.0](https://github.com/treydock/puppet-module-pcp/tree/1.1.0) (2018-05-17)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.0.0...1.1.0)

### Added

- Add cron\_ensure parameter and allow cron templates to be overridden [\#3](https://github.com/treydock/puppet-module-pcp/pull/3) ([treydock](https://github.com/treydock))

## [1.0.0](https://github.com/treydock/puppet-module-pcp/tree/1.0.0) (2017-11-13)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/0.0.3...1.0.0)

### Changed

- BREAKING: Use data types for parameters, drop support for Puppet 3 [\#1](https://github.com/treydock/puppet-module-pcp/pull/1) ([treydock](https://github.com/treydock))

### Added

- BREAKING: pmie now has concept of primary.  Requires pcp \>= 3.11.3 [\#2](https://github.com/treydock/puppet-module-pcp/pull/2) ([treydock](https://github.com/treydock))

## [0.0.3](https://github.com/treydock/puppet-module-pcp/tree/0.0.3) (2017-11-12)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/0.0.2...0.0.3)

## [0.0.2](https://github.com/treydock/puppet-module-pcp/tree/0.0.2) (2016-01-05)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/treydock/puppet-module-pcp/tree/0.0.1) (2016-01-02)

[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/f94effb45db76e4072befd3cbd7524e98138c2a4...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
