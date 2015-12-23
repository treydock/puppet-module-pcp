shared_examples_for 'pcp::config' do |facts|

  it do
    is_expected.to contain_file('/etc/pcp/pmlogger/control.d').with({
      :ensure   => 'directory',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0755',
      :recurse  => 'true',
      :purge    => 'true',
    })
  end

  it do
    is_expected.to contain_file('/etc/pcp/pmie/control.d').with({
      :ensure   => 'directory',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0755',
      :recurse  => 'true',
      :purge    => 'true',
    })
  end

  it { is_expected.not_to contain_pcp__pmlogger('local') }
  it { is_expected.not_to contain_pcp__pmie('local') }

  context 'when include_default_pmlogger => true' do
    let(:params) {{ :include_default_pmlogger => true }}
    it do
      is_expected.to contain_pcp__pmlogger('local').with({
        :primary  => 'true',
        :args     => '-r -T24h10m -c config.default',
      })
    end
  end

  context 'when include_default_pmie => true' do
    let(:params) {{ :include_default_pmie => true }}
    it do
      is_expected.to contain_pcp__pmie('local').with({
        :args => '-c config.default',
      })
    end
  end

end
