# @summary Manage PCP
#
# @example
#   include ::pcp
#
# @param ensure
#   Defines state of PCP.
#   Valid values are `running`, `stopped`, or `absent`.
#   Default is `running`.
# @param manage_repo
#   Determines if PCP repo should be managed.
#   Default is `true`.
# @param repo_baseurl
#   Base URL to pcp yum repo.
#   Default is `https://dl.bintray.com/pcp/el%{::operatingsystemmajrelease}`.
# @param repo_exclude
#   Packages to exclude from PCP repo
# @param package_ensure
#   Package ensure property.
#   Value is set to absent if `ensure` is `absent`.
#   Default is `present`.
# @param package_name
#   Name of PCP package.
#   Default is `pcp`.
# @param extra_packages
#   Array of extra packages to install for PCP
# @param service_ensure
#   Set service ensure property for `pmcd`, `pmie` and `pmlogger` services.
#   Default is based on `ensure` parameter.
# @param service_enable
#   Set service enable property for `pmcd`, `pmie` and `pmlogger` services.
#   Default is based on `ensure` parameter.
# @param enable_pmproxy
#   Boolean that determines if pmproxy service is running/enabled.
#   Default is `false`.
# @param manage_user
#   Boolean that sets if pcp user / group is managed.
#   Default is `true`.
# @param pcp_group_gid
#   pcp group GID.
#   Default is `undef`.
# @param pcp_user_uid
#   pcp user UID.
#   Default is `undef`.
# @param cron_ensure
#   Ensure passed to cron files.
#   Default based on value of `ensure`.
# @param pmlogger_cron_template
#   Template used for pmlogger cron.
#   Default is `pcp/pcp-pmlogger.cron.erb`.
# @param pmie_cron_template
#   Template used for pmie cron.
#   Default is `pcp/pcp-pmie.cron.erb`.
# @param include_default_pmlogger
#   Boolean that determines if default install pmlogger is installed.
#   Default is `true`.
# @param include_default_pmie
#   Boolean that determines if default install pmie is installed.
#   Default is `true`.
# @param pmlogger_daily_args
#   Arguments given to pmlogger_daily that is executed via cron.
#   Default is `'-X xz -x 3'`.
# @param pcp_conf_configs
#   Hash of configs to manage in /etc/pcp.conf.
# @param pmdas
#   Hash that defines `pcp::pmda` resources.
#
class pcp (
  Enum['running', 'stopped', 'absent'] $ensure  = 'running',
  # Repo
  Boolean $manage_repo                          = true,
  Optional[String] $repo_baseurl                = undef,
  Optional[String] $repo_exclude                = undef,
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
  Hash $pcp_conf_configs                        = {},
  # Resources
  Hash $pmdas                                   = {},
) {

  $osfamily = $facts.dig('os', 'family')
  $osmajor = $facts.dig('os', 'release', 'major')
  $supported = ['RedHat-6','RedHat-7','RedHat-8']
  $os = "${osfamily}-${osmajor}"
  if ! ($os in $supported) {
    fail("Unsupported OS: ${osfamily}, module ${module_name} only supports RedHat 6-8")
  }

  case $ensure {
    'running': {
      $_repo_ensure       = 'present'
      $_package_ensure    = $package_ensure
      $_directory_ensure  = 'directory'
      $_resource_ensure   = 'present'
      $_cron_default      = 'file'
      $_service_ensure_default  = 'running'
      $_service_enable_default  = true
    }
    'stopped': {
      $_repo_ensure       = 'present'
      $_package_ensure    = $package_ensure
      $_directory_ensure  = 'directory'
      $_resource_ensure   = 'present'
      $_cron_default      = 'absent'
      $_service_ensure_default  = 'stopped'
      $_service_enable_default  = false
    }
    'absent': {
      $_repo_ensure       = 'absent'
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

  $_repo_baseurl = pick($repo_baseurl, "https://dl.bintray.com/pcp/el${facts['os']['release']['major']}")
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
