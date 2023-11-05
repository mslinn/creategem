require_relative 'test_helper'

class RepositoryTest < Minitest::Test
  def test_bitbucket
    repo = Nugem::Repository.new(host:           :bitbucket,
                                 private:        true,
                                 user:           'maxmustermann',
                                 name:           :testrepo,
                                 gem_server_url: 'https://gems.mustermann.com')

    assert_equal 'git@bitbucket.org:maxmustermann/testrepo.git', repo.origin

    assert_predicate repo.private?

    assert_predicate repo.bitbucket?
  end

  def test_github
    repo = Nugem::Repository.new(host:           :github,
                                 user:           'maxmustermann',
                                 name:           :testrepo,
                                 gem_server_url: 'https://rubygems.org')

    assert_equal 'git@github.com:maxmustermann/testrepo.git', repo.origin

    assert_predicate repo.public?

    assert_predicate repo.github?
  end
end
