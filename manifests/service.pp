# Private class: See README.md.
class pcp::service {

  if $pcp::enable_pmproxy {
    $_pmproxy_ensure = 'running'
    $_pmproxy_enable = true
  } else {
    $_pmproxy_ensure = 'stopped'
    $_pmproxy_enable = false
  }

  service { 'pmcd':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'pmlogger':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'pmie':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # Disable
  #service { 'pcp':
  #  ensure     => 'running',
  #  enable     => true,
  #  hasstatus  => true,
  #  hasrestart => true,
  #}

  # Disable
  service { 'pmproxy':
    ensure     => $_pmproxy_ensure,
    enable     => $_pmproxy_enable,
    hasstatus  => true,
    hasrestart => true,
  }

}
