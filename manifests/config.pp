# Private class: See README.md.
class pcp::config {

  file { '/etc/pcp/pmlogger/control.d':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  if $pcp::include_default_pmlogger {
    pcp::pmlogger { 'local':
      primary => true,
      args    => '-r -T24h10m -c config.default'
    }
  }

  file { '/etc/pcp/pmie/control.d':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  if $pcp::include_default_pmie {
    pcp::pmie { 'local':
      args => '-c config.default',
    }
  }

  file { '/etc/cron.d/pcp-pmlogger':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pcp/pcp-pmlogger.cron.erb'),
  }

  file { '/etc/cron.d/pcp-pmie':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pcp/pcp-pmie.cron.erb'),
  }

}
