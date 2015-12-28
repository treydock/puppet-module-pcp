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
    is_expected.to contain_pcp__pmlogger('local').with({
      :primary  => 'true',
      :args     => '-r -T24h10m -c config.default',
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

  it do
    is_expected.to contain_pcp__pmie('local').with({
      :args => '-c config.default',
    })
  end

  it do
    is_expected.to contain_file('/etc/cron.d/pcp-pmlogger').with({
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  it do
    is_expected.to contain_file('/etc/cron.d/pcp-pmlogger')\
      .with_content(/^10     0  \*  \*  \*  pcp  \/usr\/libexec\/pcp\/bin\/pmlogger_daily -X xz -x 3$/)\
      .with_content(/^25,55  \*  \*  \*  \*  pcp  \/usr\/libexec\/pcp\/bin\/pmlogger_check -C$/)
  end

  it do
    is_expected.to contain_file('/etc/cron.d/pcp-pmie').with({
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  it do
    is_expected.to contain_file('/etc/cron.d/pcp-pmie')\
      .with_content(/^08     0  \*  \*  \*  pcp  \/usr\/libexec\/pcp\/bin\/pmie_daily -X xz -x 3$/)\
      .with_content(/^28,58  \*  \*  \*  \*  pcp  \/usr\/libexec\/pcp\/bin\/pmie_check -C$/)
  end

  context 'when include_default_pmlogger => false' do
    let(:params) {{ :include_default_pmlogger => false }}
    it { is_expected.not_to contain_pcp__pmlogger('local') }
  end

  context 'when include_default_pmie => false' do
    let(:params) {{ :include_default_pmie => false }}
    it { is_expected.not_to contain_pcp__pmie('local') }
  end

end
