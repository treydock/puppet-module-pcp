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

[http://treydock.github.io/puppet-module-pcp/](http://treydock.github.io/puppet-module-pcp/)

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
