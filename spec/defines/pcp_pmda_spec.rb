# frozen_string_literal: true

require 'spec_helper'

describe 'pcp::pmda' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) { 'test' }
      let(:params) { {} }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_pcp__pmda('test') }

      it do
        is_expected.to contain_package('pcp-pmda-test').with(ensure: 'present',
                                                             name: 'pcp-pmda-test',
                                                             require: 'Class[Pcp::Install]',
                                                             before: 'File_line[test-args]',
                                                             notify: 'Exec[install-test]')
      end

      it do
        is_expected.to contain_file_line('test-args').only_with(path: '/var/lib/pcp/pmdas/test/Install',
                                                                notify: 'Exec[refresh-install-test]',
                                                                ensure: 'absent',
                                                                match: '^args',
                                                                match_for_absence: 'true')
      end

      it do
        is_expected.to contain_exec('install-test').with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
                                                         command: 'touch /var/lib/pcp/pmdas/test/.NeedInstall',
                                                         creates: '/var/lib/pcp/pmdas/test/.NeedInstall',
                                                         unless: "egrep -q '^test\\s+' /etc/pcp/pmcd/pmcd.conf",
                                                         notify: 'Service[pmcd]')
      end

      it do
        is_expected.to contain_exec('refresh-install-test').with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
                                                                 command: 'touch /var/lib/pcp/pmdas/test/.NeedInstall',
                                                                 refreshonly: 'true',
                                                                 notify: 'Service[pmcd]')
      end

      it { is_expected.not_to contain_exec('remove-test') }

      context 'when has_package => false' do
        let(:params) { { has_package: false } }

        it { is_expected.not_to contain_package('pcp-pmda-test') }
      end

      context 'when config defined' do
        let(:params) { { config_content: 'some content' } }

        it do
          is_expected.to contain_file('pmda-config-dir-test').with(ensure: 'directory',
                                                                   path: '/var/lib/pcp/config/test',
                                                                   owner: 'root',
                                                                   group: 'root',
                                                                   mode: '0755',
                                                                   require: 'Class[Pcp::Install]')
        end

        it { is_expected.to contain_file('pmda-config-dir-test').that_comes_before('File[pmda-config-test]') }

        it do
          is_expected.to contain_file('pmda-config-test').with(ensure: 'file',
                                                               path: '/var/lib/pcp/config/test/test.conf',
                                                               owner: 'root',
                                                               group: 'root',
                                                               mode: '0644',
                                                               content: 'some content',
                                                               source: nil,
                                                               before: 'Exec[install-test]',
                                                               notify: 'Service[pmcd]')
        end
      end

      context 'when args defined' do
        let(:params) { { args: '-A' } }

        it do
          is_expected.to contain_file_line('test-args').only_with(path: '/var/lib/pcp/pmdas/test/Install',
                                                                  notify: 'Exec[refresh-install-test]',
                                                                  ensure: 'present',
                                                                  line: 'args="-A"',
                                                                  match: '^args',
                                                                  after: '^iam')
        end
      end

      context 'when ensure => absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.not_to contain_exec('install-test') }

        it do
          is_expected.to contain_exec('remove-test').with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
                                                          command: 'touch /var/lib/pcp/pmdas/test/.NeedRemove',
                                                          creates: '/var/lib/pcp/pmdas/test/.NeedRemove',
                                                          onlyif: 'egrep -q \'^test\s+\' /etc/pcp/pmcd/pmcd.conf',
                                                          notify: 'Service[pmcd]')
        end

        context 'when remove_package => true' do
          let(:params) { { ensure: 'absent', remove_package: true } }

          it do
            is_expected.to contain_package('pcp-pmda-test').with(ensure: 'absent',
                                                                 name: 'pcp-pmda-test',
                                                                 require: 'Exec[remove-test]',
                                                                 provider: 'rpm',
                                                                 uninstall_options: ['--nodeps'])
          end
        end
      end

      describe 'hotproc pmda' do
        let(:title) { 'proc' }
        let(:params) do
          {
            has_package: false,
            config_path: '/var/lib/pcp/pmdas/proc/hotproc.conf',
            config_content: '( (uname != "root") ) || cpuburn > 0.1'
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_package('pcp-pmda-proc') }
        it { is_expected.to contain_file('pmda-config-dir-proc') }
        it { is_expected.to contain_file('pmda-config-proc') }
        it { is_expected.to contain_file_line('proc-args').with_ensure('absent') }
        it { is_expected.to contain_exec('install-proc') }
        it { is_expected.to contain_exec('refresh-install-proc') }
      end
    end
  end
end
