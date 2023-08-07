# frozen_string_literal: true

shared_examples_for 'pcp::service' do |_facts|
  it do
    is_expected.to contain_service('pmcd').with(ensure: 'running',
                                                enable: 'true',
                                                hasstatus: 'true',
                                                hasrestart: 'true')
  end

  it { is_expected.to contain_service('pmcd').that_comes_before('Service[pmlogger]') }

  it do
    is_expected.to contain_service('pmlogger').with(ensure: 'running',
                                                    enable: 'true',
                                                    hasstatus: 'true',
                                                    hasrestart: 'true')
  end

  it { is_expected.to contain_service('pmlogger').that_comes_before('Service[pmie]') }

  it do
    is_expected.to contain_service('pmie').with(ensure: 'running',
                                                enable: 'true',
                                                hasstatus: 'true',
                                                hasrestart: 'true')
  end

  it do
    is_expected.to contain_service('pmproxy').with(ensure: 'stopped',
                                                   enable: 'false',
                                                   hasstatus: 'true',
                                                   hasrestart: 'true')
  end

  context 'when enable_pmproxy => true' do
    let(:params) { { enable_pmproxy: true } }

    it { is_expected.to contain_service('pmproxy').with_ensure('running').with_enable('true') }
  end
end
