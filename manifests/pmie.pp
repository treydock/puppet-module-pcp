# @summary
#   Configure a pmie
#
# @param ensure
#   The pmie ensure property.
#   Valid values are `present` and `absent`.
#   Default is `present`.
# @param hostname
#   Hostname associated with the pmie.
#   Default is `'LOCALHOSTNAME'`.
# @param primary
#   Boolean that sets if this pmie is primary.
#   Default is `false`.
# @param socks
#   Boolean that sets if this pmie uses pmsocks.
#   Default is `false`.
# @param log_file
#   The pmie control log file.  Default is `PCP_LOG_DIR/pmie/LOCALHOSTNAME/pmie.log`
# @param args
#   Args passed to pmie.  Default is an empty string.
# @param config_path
#   Config path for the pmie.  If defined the value is passed as `-c value` to the pmie arguments.  Default is `undef`.
# @param config_content
#   The pmie config contents.  Default is `undef`.
# @param config_source
#   The pmie config source.  Default is `undef`.
#
define pcp::pmie (
  Enum['present', 'absent'] $ensure             = 'present',
  String $hostname                              = 'LOCALHOSTNAME',
  Boolean $primary                              = false,
  Boolean $socks                                = false,
  String $log_file                              = 'PCP_LOG_DIR/pmie/LOCALHOSTNAME/pmie.log',
  String $args                                  = '', # lint:ignore:params_empty_string_assignment
  Optional[Stdlib::Absolutepath] $config_path   = undef,
  Optional[String] $config_content              = undef,
  Optional[String] $config_source               = undef,
) {
  include pcp

  Class['pcp::install'] -> Pcp::Pmie[$title]

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

  $_pmie_config_path = "/etc/pcp/pmie/control.d/${name}"
  $_line = "#This file is managed by Puppet\n${hostname} ${_primary} ${_socks} ${log_file} ${_args}\n"

  file { "pmie-${name}":
    ensure  => $ensure,
    path    => $_pmie_config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $_line,
    notify  => Service['pmie'],
  }

  if $config_path {
    file { "pmie-${name}-config":
      ensure  => $ensure,
      path    => $config_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $config_content,
      source  => $config_source,
      notify  => Service['pmie'],
      before  => File["pmie-${name}"],
    }
  }
}
