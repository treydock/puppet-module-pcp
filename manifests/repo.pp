# @api private
class pcp::repo {
  if $pcp::manage_repo {
    case $::osfamily {
      'RedHat': {
        if $pcp::ensure == 'absent' {
          file { '/etc/yum.repos.d/pcp.repo': ensure => 'absent' }
        } else {
          yumrepo { 'pcp':
            descr    => 'pcp',
            baseurl  => $pcp::repo_baseurl,
            enabled  => '1',
            gpgcheck => '0',
          }
        }
      }
      default: {
        # Do nothing
      }
    }
  }
}
