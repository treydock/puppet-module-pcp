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
end
