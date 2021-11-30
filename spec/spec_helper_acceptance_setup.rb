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
# Hack to fix issue with notify services not starting
if fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 8
  on hosts, 'mkdir -p /etc/systemd/system/{pmcd,pmlogger,pmie}.service.d'
  override = <<-EOS
[Service]
Type=simple
EOS
  create_remote_file(hosts, '/etc/systemd/system/pmcd.service.d/override.conf', override)
  create_remote_file(hosts, '/etc/systemd/system/pmlogger.service.d/override.conf', override)
  create_remote_file(hosts, '/etc/systemd/system/pmie.service.d/override.conf', override)
end
