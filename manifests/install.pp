# @api private
class pcp::install {

  if $pcp::_package_ensure != 'absent' {
    package { 'pcp':
      ensure => $pcp::_package_ensure,
      name   => $pcp::package_name,
    }

    package { 'pcp-conf':
      ensure => $pcp::_package_ensure,
    }

    package { 'pcp-doc':
      ensure => $pcp::_package_ensure,
    }

    package { 'pcp-libs':
      ensure => $pcp::_package_ensure,
    }

    package { 'perl-PCP-PMDA':
      ensure => $pcp::_package_ensure,
    }

    package { 'python-pcp':
      ensure => $pcp::_package_ensure,
    }
  } else {
    exec { 'remove pcp':
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => 'yum -y remove pcp',
      onlyif    => 'rpm -q pcp',
      logoutput => true,
    }
    exec { 'remove pcp-conf':
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => 'yum -y remove pcp-conf',
      onlyif    => 'rpm -q pcp-conf',
      logoutput => true,
    }
    exec { 'remove pcp-doc':
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => 'yum -y remove pcp-doc',
      onlyif    => 'rpm -q pcp-doc',
      logoutput => true,
    }
    exec { 'remove pcp-libs':
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => 'yum -y remove pcp-libs',
      onlyif    => 'rpm -q pcp-libs',
      logoutput => true,
    }
    exec { 'remove perl-PCP-PMDA':
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => 'yum -y remove perl-PCP-PMDA',
      onlyif    => 'rpm -q perl-PCP-PMDA',
      logoutput => true,
    }
    exec { 'remove python-pcp':
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => 'yum -y remove python-pcp',
      onlyif    => 'rpm -q python-pcp',
      logoutput => true,
    }
  }

  ensure_packages($pcp::extra_packages, {'ensure' => $pcp::_package_ensure})

}
