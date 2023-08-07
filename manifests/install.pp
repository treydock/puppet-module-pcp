# @api private
class pcp::install {
  if $pcp::_package_ensure != 'absent' {
    ensure_packages($pcp::packages, { 'ensure' => $pcp::_package_ensure })
  } else {
    $pcp::packages.each |$package| {
      exec { "remove ${package}":
        path      => '/usr/bin:/bin:/usr/sbin:/sbin',
        command   => "yum -y remove ${package}",
        onlyif    => "rpm -q ${package}",
        logoutput => true,
      }
    }
  }

  ensure_packages($pcp::extra_packages, { 'ensure' => $pcp::_package_ensure })
}
