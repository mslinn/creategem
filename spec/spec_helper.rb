require_relative '../lib/creategem'

RSpec.configure do |config|
  config.filter_run :focus
  # config.order = "random"
  config.run_all_when_everything_filtered = true

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = '../spec/status_persistence.txt'

  config.filter_run_when_matching focus: true
end
