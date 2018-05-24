# Define: pcp::pmlogger: See README.md for documentation
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

  if $config_path {
    $_args = "${args} -c ${config_path}"
  } else {
    $_args = $args
  }

  $_pmlogger_config_path = "/etc/pcp/pmlogger/control.d/${name}"
  $_line = "#This file is managed by Puppet\n${hostname} ${_primary} ${_socks} \"${log_dir}\" ${_args}\n"

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
