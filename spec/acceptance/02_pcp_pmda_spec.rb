# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'pcp::pmda define:' do
  context 'when install rsyslog pmda' do
    it 'runs successfully' do
      pp = <<-PP
        pcp::pmda { 'rsyslog':
          ensure => 'present',
        }
      PP

      apply_manifest(pp, catch_failures: true)
      # sometimes pmlogger takes a bit of time to start
      sleep(10)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp-pmda-rsyslog') do
      it { is_expected.to be_installed }
    end

    describe command('pminfo rsyslog') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  context 'when remove rsyslog pmda' do
    it 'runs successfully' do
      pp = <<-PP
        pcp::pmda { 'rsyslog':
          ensure => 'absent',
        }
      PP

      apply_manifest(pp, catch_failures: true)
      sleep(10)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp-pmda-rsyslog') do
      it { is_expected.to be_installed }
    end

    describe command('pminfo rsyslog') do
      its(:exit_status) { is_expected.not_to eq 0 }
    end
  end

  context 'when uninstall rsyslog pmda' do
    it 'runs successfully' do
      pp = <<-PP
        pcp::pmda { 'rsyslog':
          ensure          => 'absent',
          remove_package  => true,
        }
      PP

      apply_manifest(pp, catch_failures: true)
      sleep(10)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp-pmda-rsyslog') do
      it { is_expected.not_to be_installed }
    end
  end

  context 'when install nfsclient pmda', unless: (fact('os.family') == 'RedHat' && fact('os.release.major').to_i <= 6) do
    it 'runs successfully' do
      pp = <<-PP
        pcp::pmda { 'nfsclient':
          ensure => 'present',
        }
      PP

      apply_manifest(pp, catch_failures: true)
      sleep(15)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp-pmda-nfsclient') do
      it { is_expected.to be_installed }
    end

    describe command('pminfo nfsclient') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  context 'when remove nfsclient pmda', unless: (fact('os.family') == 'RedHat' && fact('os.release.major').to_i <= 6) do
    it 'runs successfully' do
      pp = <<-PP
        pcp::pmda { 'nfsclient':
          ensure => 'absent',
        }
      PP

      apply_manifest(pp, catch_failures: true)
      sleep(10)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp-pmda-nfsclient') do
      it { is_expected.to be_installed }
    end

    describe command('pminfo nfsclient') do
      its(:exit_status) { is_expected.not_to eq 0 }
    end
  end

  context 'when install proc pmda with args' do
    it 'runs successfully' do
      pp = <<-PP
        pcp::pmda { 'proc':
          ensure      => 'present',
          has_package => false,
          args        => '-A',
        }
      PP

      apply_manifest(pp, catch_failures: true)
      sleep(15)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/var/lib/pcp/pmdas/proc/Install') do
      its(:content) { is_expected.to match %r{^args="-A"$} }
    end

    describe file('/etc/pcp/pmcd/pmcd.conf') do
      its(:content) { is_expected.to match %r{^proc.*-A$} }
    end

    describe command('pminfo proc') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  context 'when remove proc pmda args' do
    it 'runs successfully' do
      pp = <<-PP
        pcp::pmda { 'proc':
          ensure      => 'present',
          has_package => false,
        }
      PP

      apply_manifest(pp, catch_failures: true)
      sleep(15)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/var/lib/pcp/pmdas/proc/Install') do
      its(:content) { is_expected.not_to match %r{^args.*} }
    end

    describe file('/etc/pcp/pmcd/pmcd.conf') do
      its(:content) { is_expected.to match %r{^proc.*pmdaproc -d 3(\s+)?$} }
    end

    describe command('pminfo proc') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
