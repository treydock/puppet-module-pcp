# Private class
class pcp::user {

  if $pcp::manage_user {
    group { 'pcp':
      ensure     => present,
      name       => 'pcp',
      gid        => $pcp::pcp_group_gid,
      system     => true,
      forcelocal => true,
    }

    user { 'pcp':
      ensure     => present,
      name       => 'pcp',
      uid        => $pcp::pcp_user_uid,
      gid        => 'pcp',
      shell      => '/sbin/nologin',
      home       => '/var/lib/pcp',
      managehome => false,
      comment    => 'Performance Co-Pilot',
      system     => true,
      forcelocal => true,
    }
  }

}
