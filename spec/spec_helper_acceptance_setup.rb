# Hack to work around issues with recent systemd and docker and running services as non-root
if fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 7
  hiera_yaml = <<-EOS
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "Common"
    path: "common.yaml"
EOS
  common_yaml = <<-EOS
---
pcp::pcp_conf_configs:
  PCP_USER: root
  PCP_GROUP: root
EOS

  create_remote_file(hosts, '/etc/puppetlabs/puppet/hiera.yaml', hiera_yaml)
  on hosts, 'mkdir -p /etc/puppetlabs/puppet/data'
  create_remote_file(hosts, '/etc/puppetlabs/puppet/data/common.yaml', common_yaml)
end