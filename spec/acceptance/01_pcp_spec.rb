# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'pcp class:' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = <<-PP
        class { 'pcp': }
      PP

      apply_manifest(pp, catch_failures: true)
      # sometimes pmlogger takes a bit of time to start
      sleep(10)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/cron.d/pcp-pmlogger') do
      it { is_expected.to be_file }
    end

    describe file('/etc/cron.d/pcp-pmie') do
      it { is_expected.to be_file }
    end

    describe service('pmcd') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe service('pmlogger') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe service('pmie') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'when pcp.conf modified', if: (fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 7) do
    it 'runs succcessfully' do
      pp = <<-PP
        class { 'pcp':
          pcp_conf_configs => {
            'PCP_RUN_DIR' => '/var/lib/pcp/run',
          },
        }
      PP

      on hosts, 'mkdir -p /var/lib/pcp/run'
      on hosts, 'mkdir -p /etc/systemd/system/pmcd.service.d'
      pmcd_unit_conf = <<-UNIT
[Service]
PIDFile=/var/lib/pcp/run/pmcd.pid
      UNIT
      create_remote_file(hosts, '/etc/systemd/system/pmcd.service.d/pid.conf', pmcd_unit_conf)
      on hosts, 'systemctl daemon-reload'
      apply_manifest(pp, catch_failures: true)
      # sometimes pmlogger takes a bit of time to start
      sleep(10)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('pmcd') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    it 'cleans up' do
      on hosts, 'rm -f /etc/systemd/system/pmcd.service.d/pid.conf'
      on hosts, 'systemctl daemon-reload'
      pp = <<-PP
        class { 'pcp':
          pcp_conf_configs => {
            'PCP_RUN_DIR' => '/run/pcp',
          },
        }
      PP
      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'when ensure => stopped' do
    it 'runs successfully' do
      pp = <<-PP
        class { 'pcp': ensure => 'stopped' }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/cron.d/pcp-pmlogger') do
      it { is_expected.not_to exist }
    end

    describe file('/etc/cron.d/pcp-pmie') do
      it { is_expected.not_to exist }
    end

    describe service('pmcd') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

    describe service('pmlogger') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

    describe service('pmie') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end

  context 'when ensure => absent' do
    it 'runs successfully' do
      pp = <<-PP
        class { 'pcp': ensure => 'absent' }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command('rpm -qa | grep -i pcp') do
      its(:exit_status) { is_expected.not_to eq 0 }
    end

    describe file('/etc/cron.d/pcp-pmlogger') do
      it { is_expected.not_to exist }
    end

    describe file('/etc/cron.d/pcp-pmie') do
      it { is_expected.not_to exist }
    end

    describe service('pmcd') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

    describe service('pmlogger') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

    describe service('pmie') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end
end
