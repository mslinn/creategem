require_relative 'test_helper'

class NugemTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Nugem::VERSION
  end
end
