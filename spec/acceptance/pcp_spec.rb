require 'spec_helper_acceptance'

describe 'pcp class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp = "
        class { 'pcp': }
        pcp::pmlogger { 'local':
          args => '-r -T24h10m -c config.default'
        }
        pcp::pmie { 'local':
          args => '-c config.default',
        }
      "

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe yumrepo('pcp') do
      it { should exist }
      it { should be_enabled }
    end

    describe package('pcp') do
      it { should be_installed }
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
end
