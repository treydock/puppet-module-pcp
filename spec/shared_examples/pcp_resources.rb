shared_examples_for 'pcp::resources' do |facts|
  it { is_expected.to have_pcp__pmda_resource_count(0) }

  context 'when pmdas defined' do
    let(:params) do
      {
        :pmdas => {
          'test' => {
            'has_package' => true,
          }
        }
      }
    end

    it { is_expected.to have_pcp__pmda_resource_count(1) }
    it { is_expected.to contain_pcp__pmda('test').with_has_package('true') }
  end
end
