require 'spec_helper'

describe 'pcp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('pcp') }

      it { is_expected.to contain_class('pcp::user').that_comes_before('Class[pcp::install]') }
      it { is_expected.to contain_class('pcp::install').that_comes_before('Class[pcp::config]') }
      it { is_expected.to contain_class('pcp::config').that_comes_before('Class[pcp::resources]') }
      it { is_expected.to contain_class('pcp::resources').that_comes_before('Class[pcp::service]') }
      it { is_expected.to contain_class('pcp::service') }

      it_behaves_like 'pcp::user', facts
      it_behaves_like 'pcp::install', facts
      it_behaves_like 'pcp::config', facts
      it_behaves_like 'pcp::resources', facts
      it_behaves_like 'pcp::service', facts
    end
  end
end
