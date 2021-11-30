# @summary Manage PCP
#
# @example
#   include ::pcp
#
# @param ensure
#   Defines state of PCP.
# @param package_ensure
#   Package ensure property.
# @param packages
#   Array of packages to install for PCP
# @param extra_packages
#   Extra packages to install
# @param service_ensure
#   Set service ensure property for `pmcd`, `pmie` and `pmlogger` services.
#   Default is based on `ensure` parameter.
# @param service_enable
#   Set service enable property for `pmcd`, `pmie` and `pmlogger` services.
#   Default is based on `ensure` parameter.
# @param enable_pmproxy
#   Boolean that determines if pmproxy service is running/enabled.
# @param manage_user
#   Boolean that sets if pcp user / group is managed.
# @param pcp_group_gid
#   pcp group GID.
# @param pcp_user_uid
#   pcp user UID.
# @param cron_ensure
#   Ensure passed to cron files.
#   Default based on value of `ensure`.
# @param pmlogger_cron_template
#   Template used for pmlogger cron.
# @param pmie_cron_template
#   Template used for pmie cron.
# @param include_default_pmlogger
#   Boolean that determines if default install pmlogger is installed.
# @param include_default_pmie
#   Boolean that determines if default install pmie is installed.
# @param pmlogger_daily_args
#   Arguments given to pmlogger_daily that is executed via cron.
# @param pcp_conf_configs
#   Hash of configs to manage in /etc/pcp.conf.
# @param pmdas
#   Hash that defines `pcp::pmda` resources.
#
class pcp (
  Enum['running', 'stopped', 'absent'] $ensure  = 'running',
  # Package
  String $package_ensure                        = 'present',
  Array $packages = ['pcp', 'pcp-conf', 'pcp-doc', 'pcp-libs', 'perl-PCP-PMDA', 'python-pcp', 'pcp-selinux'],
  Array $extra_packages = [],
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

  contain pcp::user
  contain pcp::install
  contain pcp::config
  contain pcp::resources
  contain pcp::service

  Class['pcp::user']
  -> Class['pcp::install']
  -> Class['pcp::config']
  -> Class['pcp::resources']
  -> Class['pcp::service']

}
