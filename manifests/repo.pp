# @api private
class pcp::repo {
  if $pcp::manage_repo {
    case $::osfamily {
      'RedHat': {
        yumrepo { 'pcp':
          descr    => 'pcp',
          baseurl  => $pcp::repo_baseurl,
          enabled  => '1',
          gpgcheck => '0',
        }
      }
      default: {
        # Do nothing
      }
    }
  }
}
