require 'spec_helper'

describe 'pcp::pmie' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      
      let(:title) { 'local' }
      let(:params) {{ :args => '-c config.default' }}

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_pcp__pmie('local') }

      it do
        is_expected.to contain_file('pmie-local').with({
          :ensure   => 'present',
          :path     => '/etc/pcp/pmie/control.d/local',
          :owner    => 'root',
          :group    => 'root',
          :mode     => '0644',
          :content  => "#This file is managed by Puppet\nLOCALHOSTNAME n PCP_LOG_DIR/pmie/LOCALHOSTNAME/pmie.log -c config.default\n",
          :notify   => 'Service[pmie]',
        })
      end

      it { is_expected.not_to contain_file('pmlogger-local-config') }

      context 'SUPReMM example' do
        let(:title) { 'supremm' }
        let(:params) {{
          :ensure         => 'present',
          :hostname       => 'LOCALHOSTNAME',
          :socks          => false,
          :log_file       => 'PCP_LOG_DIR/pmie/LOCALHOSTNAME/pmie.log',
          :config_path    => '/etc/pcp/pmie/pmie-supremm.config',
          :config_content => 'some content',
        }}

        it { is_expected.to contain_pcp__pmie('supremm') }

        it do
          is_expected.to contain_file('pmie-supremm').with({
            :ensure   => 'present',
            :path     => '/etc/pcp/pmie/control.d/supremm',
            :owner    => 'root',
            :group    => 'root',
            :mode     => '0644',
            :content  => "#This file is managed by Puppet\nLOCALHOSTNAME n PCP_LOG_DIR/pmie/LOCALHOSTNAME/pmie.log  -c /etc/pcp/pmie/pmie-supremm.config\n",
            :notify   => 'Service[pmie]',
          })
        end

        it do
          is_expected.to contain_file('pmie-supremm-config').with({
            :ensure   => 'present',
            :path     => '/etc/pcp/pmie/pmie-supremm.config',
            :owner    => 'root',
            :group    => 'root',
            :mode     => '0644',
            :content  => 'some content',
            :source   => nil,
            :notify   => 'Service[pmie]',
            :before   => 'File[pmie-supremm]',
          })
        end
      end

    end
  end
end