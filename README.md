# puppet-module-pcp

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/pcp.svg)](https://forge.puppetlabs.com/treydock/pcp)
[![Build Status](https://travis-ci.org/treydock/puppet-module-pcp.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-pcp)

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
    * [Public Classes](#public-classes)
    * [Public Defines](#public-defines)
4. [Compatibility](#compatibility)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module manages Performance Co-Pilot (PCP)

**Only PCP >= 3.11.3 is supported**

## Usage

To install PCP to log locally

    class { 'pcp': }

Example of using PCP without default logger and pmie as well as disabling pmlogger log archival

    class { '::pcp':
      include_default_pmlogger => false,
      include_default_pmie     => false,
      pmlogger_daily_args      => '-M -k forever',
    }

Define a new primary logger that logs to a shared location

    pcp::pmlogger { 'supremm':
      ensure         => 'present',
      hostname       => 'LOCALHOSTNAME',
      primary        => true,
      socks          => false,
      log_dir        => '/data/supremm/pmlogger/LOCALHOSTNAME',
      args           => '-r -c config.default',
    }

Install and enable a PMDA

    pcp::pmda { 'slurm': }

## Reference

* [Public Classes](#public-classes)
  * [Class: pcp](#class-pcp)
* [Private Classes](#private-classes)
* [Public Defines](#public-defines)
  * [Define: pcp::pmda](#define-pcppmda)
  * [Define: pcp::pmie](#define-pcppmie)
  * [Define: pcp::pmlogger](#define-pcppmlogger)

### Classes

#### Public Classes

* `pcp`: Install and configure PCP

#### Private Classes

* `pcp::user`: Add PCP user and group
* `pcp::install`: Install packages
* `pcp::config`: Configure PCP
* `pcp::service`: Manage services
* `pcp::resources`: Define resources
* `pcp::params`: Parameter defaults

#### Class pcp

##### Parameter defaults

    pcp::ensure: 'running'
    pcp::manage_repo: true
    pcp::repo_baseurl: "https://dl.bintray.com/pcp/el%{::operatingsystemmajrelease}"
    pcp::package_ensure: 'present'
    pcp::package_name: 'pcp'
    pcp::extra_packages: []
    pcp::enable_pmproxy: false
    pcp::manage_user: true
    #pcp::pcp_group_gid: undef
    #pcp::pcp_user_uid: undef
    pcp::include_default_pmlogger: true
    pcp::include_default_pmie: true
    pcp::pmlogger_daily_args: '-X xz -x 3'
    pcp::pmdas: {}

##### `ensure`

Defines state of PCP.  Valid values are `running`, `stopped`, or `absent`.  Default is `running`.

##### `manage_repo`

Determines if PCP repo should be managed.  Default is `true`

##### `repo_baseurl`

Base URL to pcp yum repo.

##### `package_ensure`

Package ensure property.  Value is set to absent if `ensure` is `absent`.  Default is `present`

##### `package_name`

Name of PCP package

##### `extra_packages`

Array of extra packages to install for PCP

##### `enable_pmproxy`

Boolean that determines if pmproxy service is running/enabled.  Default is `false`

##### `manage_user`

Boolean that sets if pcp user / group is managed.  Default is `true`

##### `pcp_group_gid`

pcp group GID.  Default is `undef`

##### `pcp_user_uid`

pcp user UID.  Default is `undef`

##### `include_default_pmlogger`

Boolean that determines if default install pmlogger is installed.  Default is `true`

##### `include_default_pmie`

Boolean that determines if default install pmie is installed.  Default is `true`

##### `pmlogger_daily_args`

Arguments given to pmlogger_daily that is executed via cron.  Default is `'-X xz -x 3'`

##### `pmdas`

Hash that defines `pcp::pmda` resources.

### Public Defines

#### Define pcp::pmda

Install, enable and optionally configure a PMDA

##### `ensure`

Ensure property for the PMDA.  Valid values are `'present'` and `'absent'`.  Default is `'present'`

##### `has_package`

Boolean that determines of a package is associated with the PMDA.  Default is `true`

##### `package_name`

Package name of PMDA.  Default is `pcp-pmda-$name`

##### `remove_package`

Boolean that determines if the package should be removed when `ensure` is `absent`.

##### `config_path`

Configuration file path for this PMDA.  Default is `/var/lib/pcp/config/${name}/${name}.conf`

##### `config_content`

Configuration file content for the PMDA.  Default is `undef`

##### `config_source`

Configuration file source for the PMDA.  Default is `undef`

#### Define pcp::pmie

Configure a pmie

##### `ensure`

The pmie ensure property.  Valid values are `present` and `absent`.  Default is `present`.

##### `hostname`

Hostname associated with the pmie.  Default is `'LOCALHOSTNAME'`

##### `primary`

Boolean that sets if this pmie is primary.  Default is `false`.

##### `socks`

Boolean that sets if this pmie uses pmsocks.  Default is `false`


##### `log_file`

The pmie control log file.  Default is `PCP_LOG_DIR/pmie/LOCALHOSTNAME/pmie.log`

##### `args`

Args passed to pmie.  Default is an empty string.

##### `config_path`

Config path for the pmie.  If defined the value is passed as `-c value` to the pmie arguments.  Default is `undef`.

##### `config_content`

The pmie config contents.  Default is `undef`.

##### `config_source`

The pmie config source.  Default is `undef`.

#### Define pcp::pmlogger

Configure a pmlogger

##### `ensure`

The pmlogger ensure property.  Valid values are `present` and `absent`.  Default is `present`.


##### `hostname`

Hostname associated with the pmlogger.  Default is `'LOCALHOSTNAME'`


##### `primary`

Boolean that sets if this pmlogger is primary.  Default is `false`.

##### `socks`

Boolean that sets if this pmlogger uses pmsocks.  Default is `false`


##### `log_dir`

Log directory for this pmlogger.  Default is `PCP_LOG_DIR/pmlogger/LOCALHOSTNAME`.

##### `args`

Arguments passed to pmlogger.  Default is an empty string.

##### `config_path`

Config path for the pmlogger.  If defined the value is passed as `-c value` to the pmlogger arguments.  Default is `undef`.

##### `config_content`

The pmlogger config contents.  Default is `undef`.

##### `config_source`

The pmlogger config source.  Default is `undef`.

## Compatibility

This module only works with PCP >= 3.11.3

Tested using

* CentOS 6
* CentOS 7

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker
