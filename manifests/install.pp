# @api private
class pcp::install(
  Array[String] $packages = [],
) {
  $all_packages = [$pcp::package_name] + $packages

  if $pcp::_package_ensure != 'absent' {
    ensure_packages($all_packages, {'ensure' => $pcp::_package_ensure})
  } else {
    $all_packages.each |$package| {
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
