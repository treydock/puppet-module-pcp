require 'spec_helper_acceptance'

describe 'pcp::pmda define:' do
  context 'install rsyslog pmda' do
    it 'runs successfully' do
      pp = <<-EOS
        pcp::pmda { 'rsyslog':
          ensure => 'present',
        }
      EOS

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

  context 'remove rsyslog pmda' do
    it 'runs successfully' do
      pp = <<-EOS
        pcp::pmda { 'rsyslog':
          ensure => 'absent',
        }
      EOS

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

  context 'uninstall rsyslog pmda' do
    it 'runs successfully' do
      pp = <<-EOS
        pcp::pmda { 'rsyslog':
          ensure          => 'absent',
          remove_package  => true,
        }
      EOS

      apply_manifest(pp, catch_failures: true)
      sleep(10)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pcp-pmda-rsyslog') do
      it { is_expected.not_to be_installed }
    end
  end

  context 'install nfsclient pmda' do
    it 'runs successfully' do
      pp = <<-EOS
        pcp::pmda { 'nfsclient':
          ensure => 'present',
        }
      EOS

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

  context 'remove nfsclient pmda' do
    it 'runs successfully' do
      pp = <<-EOS
        pcp::pmda { 'nfsclient':
          ensure => 'absent',
        }
      EOS

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

  context 'install proc pmda with args' do
    it 'runs successfully' do
      pp = <<-EOS
        pcp::pmda { 'proc':
          ensure      => 'present',
          has_package => false,
          args        => '-A',
        }
      EOS

      apply_manifest(pp, catch_failures: true)
      sleep(15)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/var/lib/pcp/pmdas/proc/Install') do
      its(:content) { is_expected.to match %r{^args="-A"$} }
    end

    describe file('/etc/pcp/pmcd/pmcd.conf') do
      its(:content) { is_expected.to match %r{^proc.*\-A$} }
    end

    describe command('pminfo proc') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  context 'remove proc pmda args' do
    it 'runs successfully' do
      pp = <<-EOS
        pcp::pmda { 'proc':
          ensure      => 'present',
          has_package => false,
        }
      EOS

      apply_manifest(pp, catch_failures: true)
      sleep(15)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/var/lib/pcp/pmdas/proc/Install') do
      its(:content) { is_expected.not_to match %r{^args.*} }
    end

    describe file('/etc/pcp/pmcd/pmcd.conf') do
      its(:content) { is_expected.to match %r{^proc.*pmdaproc \-d 3(\s+)?$} }
    end

    describe command('pminfo proc') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
