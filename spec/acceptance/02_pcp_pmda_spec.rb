require 'spec_helper_acceptance'

describe 'pcp::pmda define:' do
  context 'install rsyslog pmda' do
    it 'should run successfully' do
      pp =<<-EOS
        pcp::pmda { 'rsyslog':
          ensure => 'present',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # sometimes pmlogger takes a bit of time to start
      sleep(10)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pcp-pmda-rsyslog') do
      it { should be_installed }
    end

    describe command('pminfo rsyslog') do
      its(:exit_status) { should eq 0 }
    end
  end

  context 'remove rsyslog pmda' do
    it 'should run successfully' do
      pp =<<-EOS
        pcp::pmda { 'rsyslog':
          ensure => 'absent',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      sleep(10)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pcp-pmda-rsyslog') do
      it { should be_installed }
    end

    describe command('pminfo rsyslog') do
      its(:exit_status) { should_not eq 0 }
    end
  end

  context 'uninstall rsyslog pmda' do
    it 'should run successfully' do
      pp =<<-EOS
        pcp::pmda { 'rsyslog':
          ensure          => 'absent',
          remove_package  => true,
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      sleep(10)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pcp-pmda-rsyslog') do
      it { should_not be_installed }
    end
  end

  context 'install nfsclient pmda' do
    it 'should run successfully' do
      pp =<<-EOS
        pcp::pmda { 'nfsclient':
          ensure => 'present',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      sleep(15)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pcp-pmda-nfsclient') do
      it { should be_installed }
    end

    describe command('pminfo nfsclient') do
      its(:exit_status) { should eq 0 }
    end
  end

  context 'remove nfsclient pmda' do
    it 'should run successfully' do
      pp =<<-EOS
        pcp::pmda { 'nfsclient':
          ensure => 'absent',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      sleep(10)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pcp-pmda-nfsclient') do
      it { should be_installed }
    end

    describe command('pminfo nfsclient') do
      its(:exit_status) { should_not eq 0 }
    end
  end

  context 'install proc pmda with args' do
    it 'should run successfully' do
      pp =<<-EOS
        pcp::pmda { 'proc':
          ensure      => 'present',
          has_package => false,
          args        => '-A',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      sleep(15)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/var/lib/pcp/pmdas/proc/Install') do
      its(:content) { should match /^args="-A"$/ }
    end

    describe file('/etc/pcp/pmcd/pmcd.conf') do
      its(:content) { should match /^proc.*\-A$/ }
    end

    describe command('pminfo proc') do
      its(:exit_status) { should eq 0 }
    end
  end

  context 'remove proc pmda args' do
    it 'should run successfully' do
      pp =<<-EOS
        pcp::pmda { 'proc':
          ensure      => 'present',
          has_package => false,
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      sleep(15)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/var/lib/pcp/pmdas/proc/Install') do
      its(:content) { should_not match /^args.*/ }
    end

    describe file('/etc/pcp/pmcd/pmcd.conf') do
      its(:content) { should match /^proc.*pmdaproc \-d 3(\s+)?$/ }
    end

    describe command('pminfo proc') do
      its(:exit_status) { should eq 0 }
    end
  end
end
