require 'spec_helper'

describe 'pcp::pmlogger' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      
      let(:title) { 'local' }
      let(:params) {{ :primary => true, :args => '-r -T24h10m -c config.default' }}

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_pcp__pmlogger('local') }

      it do
        is_expected.to contain_file('pmlogger-local').with({
          :ensure   => 'present',
          :path     => '/etc/pcp/pmlogger/control.d/local',
          :owner    => 'root',
          :group    => 'root',
          :mode     => '0644',
          :content  => "#This file is managed by Puppet\nLOCALHOSTNAME y n PCP_LOG_DIR/pmlogger/LOCALHOSTNAME -r -T24h10m -c config.default\n",
          :notify   => 'Service[pmlogger]',
        })
      end

      it { is_expected.not_to contain_file('pmlogger-local-config') }

      context 'SUPReMM example' do
        let(:title) { 'supremm' }
        let(:params) {{
          :ensure         => 'present',
          :hostname       => 'LOCALHOSTNAME',
          :primary        => true,
          :socks          => false,
          :log_dir        => '/dne/supremm/LOCALHOSTNAME',
          :args           => '-r',
          :config_path    => '/etc/pcp/pmlogger/pmlogger-supremm.config',
          :config_content => 'some content',
        }}

        it { is_expected.to contain_pcp__pmlogger('supremm') }

        it do
          is_expected.to contain_file('pmlogger-supremm').with({
            :ensure   => 'present',
            :path     => '/etc/pcp/pmlogger/control.d/supremm',
            :owner    => 'root',
            :group    => 'root',
            :mode     => '0644',
            :content  => "#This file is managed by Puppet\nLOCALHOSTNAME y n /dne/supremm/LOCALHOSTNAME -r -c /etc/pcp/pmlogger/pmlogger-supremm.config\n",
            :notify   => 'Service[pmlogger]',
          })
        end

        it do
          is_expected.to contain_file('pmlogger-supremm-config').with({
            :ensure   => 'present',
            :path     => '/etc/pcp/pmlogger/pmlogger-supremm.config',
            :owner    => 'root',
            :group    => 'root',
            :mode     => '0644',
            :content  => 'some content',
            :source   => nil,
            :notify   => 'Service[pmlogger]',
            :before   => 'File[pmlogger-supremm]',
          })
        end
      end

    end
  end
end