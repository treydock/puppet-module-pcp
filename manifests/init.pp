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
  Optional[String] $service_ensure              = undef,
  Optional[Boolean] $service_enable             = undef,
  Boolean $enable_pmproxy                       = false,
  # User
  Boolean $manage_user                          = true,
  Optional[Integer] $pcp_group_gid              = undef,
  Optional[Integer] $pcp_user_uid               = undef,
  # Config
  Optional[String] $cron_ensure                 = undef,
  String $pmlogger_cron_template                = 'pcp/pcp-pmlogger.cron.erb',
  String $pmie_cron_template                    = 'pcp/pcp-pmie.cron.erb',
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
      $_cron_default      = 'file'
      $_service_ensure_default  = 'running'
      $_service_enable_default  = true
    }
    'stopped': {
      $_package_ensure    = $package_ensure
      $_directory_ensure  = 'directory'
      $_resource_ensure   = 'present'
      $_cron_default      = 'absent'
      $_service_ensure_default  = 'stopped'
      $_service_enable_default  = false
    }
    'absent': {
      $_package_ensure    = 'absent'
      $_directory_ensure  = 'absent'
      $_resource_ensure   = 'absent'
      $_cron_default      = 'absent'
      $_service_ensure_default  = 'stopped'
      $_service_enable_default  = false
    }
    default: {
      fail("Module ${module_name}: ensure must be either running, stopped or absent.  ${ensure} given.")
    }
  }

  $_cron_file_ensure = pick($cron_ensure, $_cron_default)
  $_service_ensure = pick($service_ensure, $_service_ensure_default)
  $_service_enable = pick($service_enable, $_service_enable_default)

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
