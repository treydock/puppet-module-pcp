require 'beaker-rspec'
require 'beaker_spec_helper'
include BeakerSpecHelper

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/shared_examples/**/*.rb"].sort.each {|f| require f}

install_puppet_on(hosts, {:version => '3.8.3'})

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('-').last

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => module_root, :module_name => module_name)

    hosts.each do |host|
      BeakerSpecHelper::spec_prep(host)
    end
  end
end