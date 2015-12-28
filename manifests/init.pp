# Class: pcp: See README.md for documentation
class pcp (
  # Repo
  $manage_repo  = true,
  $repo_baseurl = $pcp::params::repo_baseurl,

  # Package
  $package_ensure   = 'present',
  $package_name     = 'pcp',
  $extra_packages   = [],

  # Service
  $enable_pmproxy   = false,

  # User
  $manage_user      = true,
  $pcp_group_gid    = undef,
  $pcp_user_uid     = undef,

  # Config
  $include_default_pmlogger = false,
  $include_default_pmie     = false,
  $pmlogger_daily_args      = '-X xz -x 3',

  # Resources
  $pmdas                    = {},
) inherits pcp::params {

  validate_bool(
    $manage_repo,
    $enable_pmproxy,
    $manage_user,
    $include_default_pmlogger,
    $include_default_pmie
  )

  validate_string(
    $pmlogger_daily_args
  )

  validate_array(
    $extra_packages
  )

  validate_hash(
    $pmdas
  )

  anchor { 'pcp::start': }
  anchor { 'pcp::end': }

  include pcp::repo
  include pcp::user
  include pcp::install
  include pcp::config
  include pcp::resources
  include pcp::service

  Anchor['pcp::start']->
  Class['pcp::repo']->
  Class['pcp::user']->
  Class['pcp::install']->
  Class['pcp::config']->
  Class['pcp::resources']->
  Class['pcp::service']->
  Anchor['pcp::end']

}
