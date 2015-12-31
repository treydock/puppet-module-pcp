# Class: pcp: See README.md for documentation
class pcp (
  $ensure                   = 'running',
  # Repo
  $manage_repo              = true,
  $repo_baseurl             = $pcp::params::repo_baseurl,
  # Package
  $package_ensure           = 'present',
  $package_name             = 'pcp',
  $extra_packages           = [],
  # Service
  $enable_pmproxy           = false,
  # User
  $manage_user              = true,
  $pcp_group_gid            = undef,
  $pcp_user_uid             = undef,
  # Config
  $include_default_pmlogger = true,
  $include_default_pmie     = true,
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

  case $ensure {
    'running': {
      $_package_ensure    = $package_ensure
      $_directory_ensure  = 'directory'
      $_resource_ensure   = 'present'
      $_cron_file_ensure  = 'file'
      $_service_ensure    = 'running'
      $_service_enable    = true
    }
    'stopped': {
      $_package_ensure    = $package_ensure
      $_directory_ensure  = 'directory'
      $_resource_ensure   = 'present'
      $_cron_file_ensure  = 'absent'
      $_service_ensure    = 'stopped'
      $_service_enable    = false
    }
    'absent': {
      $_package_ensure    = 'absent'
      $_directory_ensure  = 'absent'
      $_resource_ensure   = 'absent'
      $_cron_file_ensure  = 'absent'
      $_service_ensure    = 'stopped'
      $_service_enable    = false
    }
    default: {
      fail("Module ${module_name}: ensure must be either running, stopped or absent.  ${ensure} given.")
    }
  }

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
