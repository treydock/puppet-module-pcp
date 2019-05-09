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
    $packages = [
      'pcp',
      'pcp-conf',
      'pcp-doc',
      'pcp-libs',
      'pearl-PCP-PMDA',
      'python-pcp',
      'pcp-selinux'
    ]
    $packages.each |$package| {
      exec { "remove ${package}":
        path      => '/usr/bin:/bin:/usr/sbin:/sbin',
        command   => "yum -y remove ${package}",
        onlyif    => "rpm -q ${package}",
        logoutput => true,
      }
    }
  }

  ensure_packages($pcp::extra_packages, {'ensure' => $pcp::_package_ensure})

}
