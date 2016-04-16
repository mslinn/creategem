# Creategem

[![Gem Version](http://img.shields.io/gem/v/creategem.svg)][gem]
[![Build Status](http://img.shields.io/travis/igorj/creategem.svg)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/igorj/creategem.svg)][gemnasium]
[![Code Climate](http://img.shields.io/codeclimate/github/igorj/creategem.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/igorj/creategem.svg)][coveralls]

[gem]: https://rubygems.org/gems/creategem
[travis]: http://travis-ci.org/igorj/creategem
[gemnasium]: https://gemnasium.com/igorj/creategem
[codeclimate]: https://codeclimate.com/github/igorj/creategem
[coveralls]: https://coveralls.io/r/igorj/creategem

Creategem creates a scaffold project for a new gem together with remote repository (Github or Bitbucket) and is ready to be released in a public or private gem server.  
 
This project is inspired by the [Bundler](http://bundler.io)'s `bundle gem GEM` command and by the great article [Deveoping a RubyGem using Bundler](https://github.com/radar/guides/blob/master/gem-development.md).

Similar to what Bundler's bundle gem command does, this gem generates a scaffold with all files you need to start, but it also has some additional features.
 
Features:
- automatically creates local and remote git repository (github or bitbucket) for your gem 
- automatically release patches, minor and major versions without having to manually increase versions (thanks to [gem-release](https://github.com/svenfuchs/gem-release))
- executable based on [Thor](http://whatisthor.com) (can be omited with --no-executable)
- test infrastructure based on minitest and minitest-reporters
- release to rubygems.org or to private geminabox gem server
- readme with badges for travis, codeclimate, coveralls, etc. for public projects
 

## Installation

    $ gem install creategem


## Usage

    $ creategem gem GEM_NAME [--private] [--no-executable]
    
When called without any options it is assumed that you want a gem with an executable and hosted in a public github git repository, and released to rubygems.org. 
    
During the creation you will be asked for your github user name (only the first time, as the user name is saved in your git global config). You will also be asked to enter your github password when the remote repository is created for you with the github rest api. 
    
When you use the `--private` option a bitbucket repository is created for the gem and on release the gem is pushed to a private Geminabox server. 
    
During the creation you will be asked for your bitbucket user name and the url of your geminabox gem server (only the first time, as the user name and the gem server url are saved in your git global config). You will also be asked to enter your bitbucket password when the remote repository is created for you with the bitbucket rest api.     

Per default a gem is created with an executable based on Thor, but you can omit the executable with the option `--no-executable`. 

After you create the gem, edit your gemspec and change the summary and the description, commit the changes to git and invoke `rake release_patch` and your gem is being released. 


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, run `bundle exec rake release_patch`, `bundle exec rake release_minor`, oder `bundle exec rake release_major`, 
which will create a git tag for the version, push git commits and tags, and push the `.gem` file to https://rubygems.org.

## Contributing

Bug reports and pull requests are welcome on Github at https://github.com/igorj/creategem.

