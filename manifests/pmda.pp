# Define: pcp::pmda: See README.md for documentation
define pcp::pmda (
  $ensure         = 'present',
  $has_package    = false,
  $package_name   = undef,
) {

  require 'pcp'

  validate_bool(
    $has_package
  )

  $_package_name = pick($package_name, "pcp-pmda-${name}")
  $_pmda_dir     = "/var/lib/pcp/pmdas/${name}"

  case $ensure {
    'present': {
      $_package_require = undef
      $_package_notify  = Exec["install-${name}"]
    }
    'absent': {
      $_package_require = Exec["remove-${name}"]
      $_package_notify = undef
    }
    default: {
      fail("pcp::pmda: ensure must be present or absent, ${ensure} given.")
    }
  }

  if $has_package {
    package { $_package_name:
      ensure  => $ensure,
      require => $_package_require,
      notify  => $_package_notify,
    }
  }

  if $ensure == 'present' {
    exec { "install-${name}":
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => "touch ${_pmda_dir}/.NeedInstall",
      creates     => "${_pmda_dir}/.NeedInstall",
      refreshonly => true,
      notify      => Service['pmcd'],
    }
  }

  if $ensure == 'absent' {
    exec { "remove-${name}":
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => "${_pmda_dir}/Remove",
      onlyif  => "test -d ${_pmda_dir}",
    }
  }

}
