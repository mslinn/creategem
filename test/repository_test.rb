require_relative 'test_helper'

class RepositoryTest < Minitest::Test
  def test_bitbucket
    repo = Creategem::Repository.new(host:           :bitbucket,
                                     private:        true,
                                     user:           'maxmustermann',
                                     name:           :testrepo,
                                     gem_server_url: 'https://gems.mustermann.com')
    assert_equal 'git@bitbucket.org:maxmustermann/testrepo.git', repo.origin
    assert repo.private?
    assert repo.bitbucket?
  end

  def test_github
    repo = Creategem::Repository.new(host:           :github,
                                     user:           'maxmustermann',
                                     name:           :testrepo,
                                     gem_server_url: 'https://rubygems.org')
    assert_equal 'git@github.com:maxmustermann/testrepo.git', repo.origin
    assert repo.public?
    assert repo.github?
  end
end
