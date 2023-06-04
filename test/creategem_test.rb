require_relative 'test_helper'

class CreategemTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Creategem::VERSION
  end
end
