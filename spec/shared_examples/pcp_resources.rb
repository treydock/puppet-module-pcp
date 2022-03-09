shared_examples_for 'pcp::resources' do |_facts|
  it { is_expected.to have_pcp__pmda_resource_count(0) }
  it { is_expected.to have_pcp__pmie_resource_count(1) }
  it { is_expected.to have_pcp__pmlogger_resource_count(1) }

  context 'when pmdas defined' do
    let(:params) do
      {
        pmdas: {
          'test' => {
            'has_package' => true,
          },
        },
        pmies: {
          'test' => {
            'log_file' => 'EXAMPLE',
          },
        },
        pmloggers: {
          'test' => {
            'log_dir' => 'EXAMPLE',
          },
        },
      }
    end

    it { is_expected.to have_pcp__pmda_resource_count(1) }
    it { is_expected.to contain_pcp__pmda('test').with_has_package('true') }

    it { is_expected.to have_pcp__pmie_resource_count(1) }
    it { is_expected.to contain_pcp__pmie('test').with_log_file('EXAMPLE') }

    it { is_expected.to have_pcp__pmlogger_resource_count(1) }
    it { is_expected.to contain_pcp__pmlogger('test').with_log_dir('EXAMPLE') }
  end
end
