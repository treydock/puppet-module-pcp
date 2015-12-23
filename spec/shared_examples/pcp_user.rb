shared_examples_for 'pcp::user' do |facts|
  it do
    is_expected.to contain_group('pcp').with({
      :ensure     => 'present',
      :name       => 'pcp',
      :gid        => nil,
      :system     => 'true',
      :forcelocal => 'true',
    })
  end

  it do
    is_expected.to contain_user('pcp').with({
      :ensure     => 'present',
      :name       => 'pcp',
      :uid        => nil,
      :gid        => 'pcp',
      :shell      => '/sbin/nologin',
      :home       => '/var/lib/pcp',
      :managehome => 'false',
      :comment    => 'Performance Co-Pilot',
      :system     => 'true',
      :forcelocal => 'true',
    })
  end

  context 'when pcp_group_gid defined' do
    let(:params) {{ :pcp_group_gid => '99' }}
    it { is_expected.to contain_group('pcp').with_gid('99') }
  end

  context 'when pcp_user_uid defined' do
    let(:params) {{ :pcp_user_uid => '99' }}
    it { is_expected.to contain_user('pcp').with_uid('99') }
  end

  context 'when manage_user => false' do
    let(:params) {{ :manage_user => false }}
    it { is_expected.not_to contain_group('pcp') }
    it { is_expected.not_to contain_user('pcp') }
  end
end
