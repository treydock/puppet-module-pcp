require 'spec_helper'

describe 'pcp::pmda' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      
      let(:title) { 'test' }
      let(:params) {{ }}

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_pcp__pmda('test') }
      it { is_expected.not_to contain_package('pcp-pmda-test') }

      it do
        is_expected.to contain_exec('install-test').with({
          :path         => '/usr/bin:/bin:/usr/sbin:/sbin',
          :command      => 'touch /var/lib/pcp/pmdas/test/.NeedInstall',
          :creates      => '/var/lib/pcp/pmdas/test/.NeedInstall',
          :refreshonly  => 'true',
          :notify       => 'Service[pmcd]',
        })
      end

      it { is_expected.not_to contain_exec('remove-test') }

      context 'when has_package => true' do
        let(:params) {{ :has_package => true }}

        it do
          is_expected.to contain_package('pcp-pmda-test').with({
            :ensure   => 'present',
            :require  => 'Class[Pcp::Repo]',
            :notify   => 'Exec[install-test]',
          })
        end
      end

      context 'when ensure => absent' do
        let(:params) {{ :ensure => 'absent' }}

        it { is_expected.not_to contain_package('pcp-pmda-test') }
        it { is_expected.not_to contain_exec('install-test') }

        it do
          is_expected.to contain_exec('remove-test').with({
            :path     => '/usr/bin:/bin:/usr/sbin:/sbin',
            :command  => '/var/lib/pcp/pmdas/test/Remove',
            :onlyif   => 'test -d /var/lib/pcp/pmdas/test',
          })
        end

        context 'when has_package => true' do
          let(:params) {{ :ensure => 'absent', :has_package => true }}

          it do
            is_expected.to contain_package('pcp-pmda-test').with({
              :ensure   => 'absent',
              :require  => 'Exec[remove-test]',
              :notify   => nil,
            })
          end
        end
      end

      context 'when config defined' do
        let(:params) {{ :config_content => 'some content' }}

        it do
          is_expected.to contain_file('pmda-config-test').with({
            :ensure   => 'present',
            :path     => '/var/lib/pcp/config/test/test.conf',
            :owner    => 'root',
            :group    => 'root',
            :mode     => '0644',
            :content  => 'some content',
            :source   => nil,
            :require  => nil,
            :before   => 'Exec[install-test]',
            :notify   => 'Service[pmcd]',
          })
        end
      end

    end
  end
end