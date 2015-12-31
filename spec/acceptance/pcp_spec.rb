require 'spec_helper_acceptance'

describe 'pcp class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'pcp': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # sometimes pmlogger takes a bit of time to start
      sleep(10)
      apply_manifest(pp, :catch_changes => true)
    end

    describe yumrepo('pcp') do
      it { should exist }
      it { should be_enabled }
    end

    describe package('pcp') do
      it { should be_installed }
    end

    describe file('/etc/cron.d/pcp-pmlogger') do
      it { should be_file }
    end

    describe file('/etc/cron.d/pcp-pmie') do
      it { should be_file }
    end

    describe service('pmcd') do
      it { should be_running }
      it { should be_enabled }
    end

    describe service('pmlogger') do
      it { should be_running }
      it { should be_enabled }
    end

    describe service('pmie') do
      it { should be_running }
      it { should be_enabled }
    end
  end

  context 'when ensure => stopped' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'pcp': ensure => 'stopped' }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pcp') do
      it { should be_installed }
    end

    describe file('/etc/cron.d/pcp-pmlogger') do
      it { should_not exist }
    end

    describe file('/etc/cron.d/pcp-pmie') do
      it { should_not exist }
    end

    describe service('pmcd') do
      it { should_not be_running }
      it { should_not be_enabled }
    end

    describe service('pmlogger') do
      it { should_not be_running }
      it { should_not be_enabled }
    end

    describe service('pmie') do
      it { should_not be_running }
      it { should_not be_enabled }
    end
  end

  context 'when ensure => absent' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'pcp': ensure => 'absent' }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pcp') do
      it { should_not be_installed }
    end

    describe file('/etc/cron.d/pcp-pmlogger') do
      it { should_not exist }
    end

    describe file('/etc/cron.d/pcp-pmie') do
      it { should_not exist }
    end

    describe service('pmcd') do
      it { should_not be_running }
      it { should_not be_enabled }
    end

    describe service('pmlogger') do
      it { should_not be_running }
      it { should_not be_enabled }
    end

    describe service('pmie') do
      it { should_not be_running }
      it { should_not be_enabled }
    end
  end
end
