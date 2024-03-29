# frozen_string_literal: true

shared_examples_for 'pcp::install' do |facts|
  packages = if facts[:os]['release']['major'].to_s == '7'
               [
                 'pcp',
                 'pcp-conf',
                 'pcp-doc',
                 'pcp-libs',
                 'perl-PCP-PMDA',
                 'python-pcp',
                 'pcp-selinux'
               ]
             else
               [
                 'pcp',
                 'pcp-conf',
                 'pcp-doc',
                 'pcp-libs',
                 'perl-PCP-PMDA',
                 'python3-pcp',
                 'pcp-selinux'
               ]
             end

  it { is_expected.to have_package_resource_count(packages.size) }

  packages.each do |package|
    it { is_expected.to contain_package(package).with_ensure('installed') }
  end

  context 'when package_ensure => latest' do
    let(:params) { { package_ensure: 'latest' } }

    packages.each do |package|
      it { is_expected.to contain_package(package).with_ensure('latest') }
    end
  end

  context 'when extra_packages defined' do
    let(:params) { { extra_packages: ['pcp-foo'] } }

    it { is_expected.to have_package_resource_count(packages.size + 1) }

    packages.each do |package|
      it { is_expected.to contain_package(package).with_ensure('installed') }
    end
    it { is_expected.to contain_package('pcp-foo').with_ensure('installed') }

    context 'when package_ensure => latest' do
      let(:params) { { extra_packages: ['pcp-foo'], package_ensure: 'latest' } }

      it { is_expected.to contain_package('pcp-foo').with_ensure('latest') }
    end
  end
end
