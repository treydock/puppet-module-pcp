# Define: pcp::pmda: See README.md for documentation
define pcp::pmda (
  $ensure           = 'present',
  $has_package      = false,
  $package_name     = undef,
  $config_path      = undef,
  $config_dir_name  = $title,
  $config_content   = undef,
  $config_source    = undef,
) {

  include pcp

  validate_bool(
    $has_package
  )

  $_package_name = pick($package_name, "pcp-pmda-${name}")
  $_config_path  = "/var/lib/pcp/config/${config_dir_name}/${name}.conf"
  $_pmda_dir     = "/var/lib/pcp/pmdas/${name}"

  case $ensure {
    'present': {
      $_package_require = Class['pcp::repo']
      $_package_notify  = Exec["install-${name}"]
      $_config_before   = Exec["install-${name}"]
    }
    'absent': {
      $_package_require = Exec["remove-${name}"]
      $_package_notify  = undef
      $_config_before   = Exec["remove-${name}"]
    }
    default: {
      fail("pcp::pmda: ensure must be present or absent, ${ensure} given.")
    }
  }

  if $has_package {
    $_config_require = Package["pcp-pmda-${name}"]

    package { "pcp-pmda-${name}":
      ensure  => $ensure,
      name    => $_package_name,
      require => $_package_require,
      notify  => $_package_notify,
    }
  } else {
    $_config_require = undef
  }

  if $config_content or $config_source {
    file { "pmda-config-${name}":
      ensure  => $ensure,
      path    => $_config_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $config_content,
      source  => $config_source,
      require => $_config_require,
      before  => $_config_before,
      notify  => Service['pmcd'],
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
