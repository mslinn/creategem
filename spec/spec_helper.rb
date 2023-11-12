require_relative '../lib/nugem'

RSpec.configure do |config|
  config.filter_run_when_matching focus: true
  # config.order = "random"

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = '../spec/status_persistence.txt'
end
