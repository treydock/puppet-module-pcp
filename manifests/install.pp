# Private class: See README.md.
class pcp::install {

  package { 'pcp':
    ensure => $pcp::package_ensure,
    name   => $pcp::package_name,
  }

  ensure_packages($pcp::extra_packages, {'ensure' => $pcp::package_ensure})

}
