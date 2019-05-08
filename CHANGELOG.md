## [1.4.3](https://github.com/treydock/puppet-module-pcp/tree/1.4.3) (2019-05-08)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.4.2...1.4.3)

**Fixed bugs:**

- Remove pcp-selinux when ensure is absent [\#14](https://github.com/treydock/puppet-module-pcp/pull/14) ([treydock](https://github.com/treydock))

## [1.4.2](https://github.com/treydock/puppet-module-pcp/tree/1.4.2) (2019-05-07)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.4.1...1.4.2)

**Fixed bugs:**

- Remove repo when ensure is absent [\#13](https://github.com/treydock/puppet-module-pcp/pull/13) ([treydock](https://github.com/treydock))

## [1.4.1](https://github.com/treydock/puppet-module-pcp/tree/1.4.1) (2018-12-18)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.4.0...1.4.1)

**Fixed bugs:**

- Fix removal of pmda config directory [\#12](https://github.com/treydock/puppet-module-pcp/pull/12) ([treydock](https://github.com/treydock))

## [1.4.0](https://github.com/treydock/puppet-module-pcp/tree/1.4.0) (2018-12-04)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.3.1...1.4.0)

**Implemented enhancements:**

- Support puppet 6 and drop puppet 4 [\#11](https://github.com/treydock/puppet-module-pcp/pull/11) ([treydock](https://github.com/treydock))
- Support setting pmda arguments [\#9](https://github.com/treydock/puppet-module-pcp/pull/9) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Use beaker 4.x [\#10](https://github.com/treydock/puppet-module-pcp/pull/10) ([treydock](https://github.com/treydock))

**Merged pull requests:**

- Document with puppet-strings [\#8](https://github.com/treydock/puppet-module-pcp/pull/8) ([treydock](https://github.com/treydock))

## [1.3.1](https://github.com/treydock/puppet-module-pcp/tree/1.3.1) (2018-06-29)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.3.0...1.3.1)

**Fixed bugs:**

- Fix service start order for pmcd and pmlogger [\#7](https://github.com/treydock/puppet-module-pcp/pull/7) ([treydock](https://github.com/treydock))

## [1.3.0](https://github.com/treydock/puppet-module-pcp/tree/1.3.0) (2018-05-24)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.2.0...1.3.0)

**Implemented enhancements:**

- Quote pmlogger log directory path [\#6](https://github.com/treydock/puppet-module-pcp/pull/6) ([treydock](https://github.com/treydock))

## [1.2.0](https://github.com/treydock/puppet-module-pcp/tree/1.2.0) (2018-05-18)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.1.1...1.2.0)

**Implemented enhancements:**

- Add service\_ensure and service\_enable parameters. [\#5](https://github.com/treydock/puppet-module-pcp/pull/5) ([treydock](https://github.com/treydock))

## [1.1.1](https://github.com/treydock/puppet-module-pcp/tree/1.1.1) (2018-05-17)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.1.0...1.1.1)

**Merged pull requests:**

- Update README [\#4](https://github.com/treydock/puppet-module-pcp/pull/4) ([treydock](https://github.com/treydock))

## [1.1.0](https://github.com/treydock/puppet-module-pcp/tree/1.1.0) (2018-05-17)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/1.0.0...1.1.0)

**Implemented enhancements:**

- Add cron\_ensure parameter and allow cron templates to be overridden [\#3](https://github.com/treydock/puppet-module-pcp/pull/3) ([treydock](https://github.com/treydock))

## [1.0.0](https://github.com/treydock/puppet-module-pcp/tree/1.0.0) (2017-11-12)
[Full Changelog](https://github.com/treydock/puppet-module-pcp/compare/0.0.3...1.0.0)

**Implemented enhancements:**

- BREAKING: pmie now has concept of primary.  Requires pcp \>= 3.11.3 [\#2](https://github.com/treydock/puppet-module-pcp/pull/2) ([treydock](https://github.com/treydock))

**Merged pull requests:**

- BREAKING: Use data types for parameters, drop support for Puppet 3 [\#1](https://github.com/treydock/puppet-module-pcp/pull/1) ([treydock](https://github.com/treydock))

## 0.0.3 - 2017-11-11

Bugfix release

* Fix mode on pmda config directory
* Updates to regression tests

## 0.0.2 - 2016-01-05

### Summary

This release improves PMDA detection and removal.

## 0.0.1 - 2016-01-02

### Summary

Initial release
