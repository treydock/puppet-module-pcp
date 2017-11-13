# Class: pcp: See README.md for documentation
class pcp (
  Enum['running', 'stopped', 'absent'] $ensure  = 'running',
  # Repo
  Boolean $manage_repo                          = true,
  String $repo_baseurl                          = $pcp::params::repo_baseurl,
  # Package
  String $package_ensure                        = 'present',
  String $package_name                          = 'pcp',
  Array $extra_packages                         = [],
  # Service
  Boolean $enable_pmproxy                       = false,
  # User
  Boolean $manage_user                          = true,
  Optional[Integer] $pcp_group_gid              = undef,
  Optional[Integer] $pcp_user_uid               = undef,
  # Config
  Boolean $include_default_pmlogger             = true,
  Boolean $include_default_pmie                 = true,
  String $pmlogger_daily_args                   = '-X xz -x 3',
  # Resources
  Hash $pmdas                                   = {},
) inherits pcp::params {

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

  Anchor['pcp::start']
  -> Class['pcp::repo']
  -> Class['pcp::user']
  -> Class['pcp::install']
  -> Class['pcp::config']
  -> Class['pcp::resources']
  -> Class['pcp::service']
  -> Anchor['pcp::end']

}
