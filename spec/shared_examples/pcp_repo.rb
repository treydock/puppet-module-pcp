shared_examples_for 'pcp::repo' do |facts|
  it do
    is_expected.to contain_yumrepo('pcp').with(descr: 'pcp',
                                               baseurl: "https://dl.bintray.com/pcp/el#{facts[:operatingsystemmajrelease]}",
                                               enabled: '1',
                                               gpgcheck: '0',
                                               exclude: nil)
  end

  context 'when repo_baseurl set' do
    let(:params) { { repo_baseurl: 'http://foo.example.com/pcp/$releasever' } }

    it { is_expected.to contain_yumrepo('pcp').with_baseurl('http://foo.example.com/pcp/$releasever') }
  end

  context 'when manage_repo => false' do
    let(:params) { { manage_repo: false } }

    it { is_expected.not_to contain_yumrepo('pcp') }
  end

  context 'when repo_exclude defined' do
    let(:params) { { repo_exclude: 'pcp-system-tools' } }

    it { is_expected.to contain_yumrepo('pcp').with_exclude('pcp-system-tools') }
  end
end
