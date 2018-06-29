# @api private
class pcp::config {

  file { '/etc/pcp/pmlogger/control.d':
    ensure  => $pcp::_directory_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    force   => true,
  }

  if $pcp::include_default_pmlogger {
    pcp::pmlogger { 'local':
      ensure  => $pcp::_resource_ensure,
      primary => true,
      args    => '-r -T24h10m -c config.default'
    }
  }

  file { '/etc/pcp/pmie/control.d':
    ensure  => $pcp::_directory_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    force   => true,
  }

  if $pcp::include_default_pmie {
    pcp::pmie { 'local':
      ensure  => $pcp::_resource_ensure,
      primary => true,
      args    => '-c config.default',
    }
  }

  file { '/etc/cron.d/pcp-pmlogger':
    ensure  => $pcp::_cron_file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($pcp::pmlogger_cron_template),
  }

  file { '/etc/cron.d/pcp-pmie':
    ensure  => $pcp::_cron_file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($pcp::pmie_cron_template),
  }

}
