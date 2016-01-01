# Define: pcp::pmda: See README.md for documentation
define pcp::pmda (
  $ensure           = 'present',
  $has_package      = true,
  $package_name     = undef,
  $remove_package   = false,
  $config_path      = undef,
  $config_content   = undef,
  $config_source    = undef,
) {

  include pcp

  validate_bool(
    $has_package,
    $remove_package
  )

  $_package_name = pick($package_name, "pcp-pmda-${name}")
  $_config_path  = pick($config_path, "/var/lib/pcp/config/${name}/${name}.conf")
  $_config_dir   = dirname($_config_path)
  $_pmda_dir     = "/var/lib/pcp/pmdas/${name}"

  case $ensure {
    'present': {
      if $has_package {
        package { "pcp-pmda-${name}":
          ensure  => $pcp::_package_ensure,
          name    => $_package_name,
          require => Class['pcp::install'],
          notify  => Exec["install-${name}"],
        }
      }

      if $config_content or $config_source {
        file { "pmda-config-dir-${name}":
          ensure  => 'directory',
          path    => $_config_dir,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          require => Class['pcp::install'],
        }->
        file { "pmda-config-${name}":
          ensure  => 'file',
          path    => $_config_path,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => $config_content,
          source  => $config_source,
          before  => Exec["install-${name}"],
          notify  => Service['pmcd'],
        }
      }

      exec { "install-${name}":
        command => "/bin/touch ${_pmda_dir}/.NeedInstall",
        creates => "${_pmda_dir}/.NeedInstall",
        unless  => "/usr/bin/pminfo ${name}",
        notify  => Service['pmcd'],
      }
    }
    'absent': {
      if $remove_package and $has_package {
        package { "pcp-pmda-${name}":
          ensure            => 'absent',
          name              => $_package_name,
          require           => Exec["remove-${name}"],
          provider          => 'rpm',
          uninstall_options => ['--nodeps'],
        }
      }

      if $config_content or $config_source {
        file { "pmda-config-${name}":
          ensure => 'absent',
          path   => $_config_path,
        }->
        file { "pmda-config-dir-${name}":
          ensure => 'absent',
          path   => $_config_dir,
        }
      }

      exec { "remove-${name}":
        path    => "${_pmda_dir}:/usr/bin:/bin:/usr/sbin:/sbin",
        cwd     => $_pmda_dir,
        command => 'Remove',
        onlyif  => [
          "test -f ${_pmda_dir}/Remove",
          "/usr/bin/pminfo ${name}",
        ],
        require => Class['pcp::install'],
      }
    }
    default: {
      fail("pcp::pmda: ensure must be present or absent, ${ensure} given.")
    }
  }

}
