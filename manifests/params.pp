# Private class: See README.md.
class pcp::params {

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemmajrelease, '6') < 0 {
        fail("Unsupported operatingsystemmajrelease: ${::operatingsystemmajrelease} for ${::osfamily}, only support 6 and 7.")
      }
      $repo_baseurl = "https://dl.bintray.com/pcp/el${::operatingsystemmajrelease}"
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
