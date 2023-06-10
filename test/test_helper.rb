require_relative '../lib/creategem'

require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
