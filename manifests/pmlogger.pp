# @summary
#   Configure a pmlogger
#
# @param ensure
#   The pmlogger ensure property.
#   Valid values are `present` and `absent`.
#   Default is `present`.
# @param hostname
#   Hostname associated with the pmlogger.
#   Default is `'LOCALHOSTNAME'`.
# @param primary
#   Boolean that sets if this pmlogger is primary.
#   Default is `false`.
# @param socks
#   Boolean that sets if this pmlogger uses pmsocks.
#   Default is `false`.
# @param log_dir
#   Log directory for this pmlogger.
#   Default is `PCP_LOG_DIR/pmlogger/LOCALHOSTNAME`.
# @param args
#   Arguments passed to pmlogger.
#   Default is an empty string.
# @param config_path
#   Config path for the pmlogger.
#   If defined the value is passed as `-c value` to the pmlogger arguments.
#   Default is `undef`.
# @param config_content
#   The pmlogger config contents.
#   Default is `undef`.
# @param config_source
#   The pmlogger config source.
#   Default is `undef`.
#
define pcp::pmlogger (
  Enum['present', 'absent'] $ensure             = 'present',
  String $hostname                              = 'LOCALHOSTNAME',
  Boolean $primary                              = false,
  Boolean $socks                                = false,
  String $log_dir                               = 'PCP_LOG_DIR/pmlogger/LOCALHOSTNAME',
  String $args                                  = '',
  Optional[Stdlib::Absolutepath] $config_path   = undef,
  Optional[String] $config_content              = undef,
  Optional[String] $config_source               = undef,
) {

  include pcp

  Class['pcp::install'] -> Pcp::Pmlogger[$title]

  if $primary {
    $_primary = 'y'
  } else {
    $_primary = 'n'
  }

  if $socks {
    $_socks = 'y'
  } else {
    $_socks = 'n'
  }

  if $log_dir =~ /\$/ {
    $_log_dir = "\"${log_dir}\""
  } else {
    $_log_dir = $log_dir
  }

  if $config_path {
    $_args = "${args} -c ${config_path}"
  } else {
    $_args = $args
  }

  $_pmlogger_config_path = "/etc/pcp/pmlogger/control.d/${name}"
  $_line = "#This file is managed by Puppet\n${hostname} ${_primary} ${_socks} ${_log_dir} ${_args}\n"

  file { "pmlogger-${name}":
    ensure  => $ensure,
    path    => $_pmlogger_config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $_line,
    notify  => Service['pmlogger'],
  }

  if $config_path {
    file { "pmlogger-${name}-config":
      ensure  => $ensure,
      path    => $config_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $config_content,
      source  => $config_source,
      notify  => Service['pmlogger'],
      before  => File["pmlogger-${name}"],
    }
  }

}
