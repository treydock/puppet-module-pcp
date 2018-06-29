# @summary
#   Install, enable and optionally configure a PMDA
#
# @example
#   pcp::pmda { 'nfsclient':
#     ensure => 'present',
#   }
#
# @param ensure
#   Ensure property for the PMDA.
#   Valid values are `'present'` and `'absent'`.
#   Default is `'present'`.
# @param has_package
#   Boolean that determines of a package is associated with the PMDA.
#   Default is `true`.
# @param package_name
#   Package name of PMDA.
#   Default is `pcp-pmda-$name`.
# @param remove_package
#   Boolean that determines if the package should be removed when `ensure` is `absent`.
#   Default is `false`.
# @param config_path
#   Configuration file path for this PMDA.
#   Default is `/var/lib/pcp/config/${name}/${name}.conf`.
# @param config_content
#   Configuration file content for the PMDA.
#   Default is `undef`.
# @param config_source
#   Configuration file source for the PMDA.
#   Default is `undef`.
#
define pcp::pmda (
  Enum['present', 'absent'] $ensure           = 'present',
  Boolean $has_package                        = true,
  Optional[String] $package_name              = undef,
  Boolean $remove_package                     = false,
  Optional[Stdlib::Absolutepath] $config_path = undef,
  Optional[String] $config_content            = undef,
  Optional[String] $config_source             = undef,
) {

  include pcp

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
          mode    => '0755',
          require => Class['pcp::install'],
        }
        -> file { "pmda-config-${name}":
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
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "touch ${_pmda_dir}/.NeedInstall",
        creates => "${_pmda_dir}/.NeedInstall",
        unless  => "egrep -q '^${name}\\s+' /etc/pcp/pmcd/pmcd.conf",
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
        }
        -> file { "pmda-config-dir-${name}":
          ensure => 'absent',
          path   => $_config_dir,
        }
      }

      exec { "remove-${name}":
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "touch ${_pmda_dir}/.NeedRemove",
        creates => "${_pmda_dir}/.NeedRemove",
        onlyif  => "egrep -q '^${name}\\s+' /etc/pcp/pmcd/pmcd.conf",
        notify  => Service['pmcd'],
      }
    }
    default: {
      fail("pcp::pmda: ensure must be present or absent, ${ensure} given.")
    }
  }

}
