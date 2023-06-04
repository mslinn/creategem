# Creategem

[![Gem Version](http://img.shields.io/gem/v/creategem.svg)][gem]
[![Coverage Status](http://img.shields.io/coveralls/igorj/creategem.svg)][coveralls]

[gem]: https://rubygems.org/gems/creategem
[gemnasium]: https://gemnasium.com/igorj/creategem
[coveralls]: https://coveralls.io/r/igorj/creategem

Creategem creates a scaffold project for a new gem together with remote repository (Github or Bitbucket)
that is ready to be released to a public or private gem server.

This project was inspired by the [Bundler](http://bundler.io)'s `bundle gem` subcommand,
and by [Deveoping a RubyGem using Bundler](https://github.com/radar/guides/blob/master/gem-development.md).

Similar to what Bundler's `bundle gem` command does, this gem generates a scaffold with all files you need to start, but it also has some additional features.

Features:
- automatically creates local and remote git repository (github or bitbucket) for your gem
- option to create private github and bitbucket repositories
- automatically release patches, minor and major versions without having to manually increase versions (thanks to [gem-release](https://github.com/svenfuchs/gem-release))
- executable based on [Thor](http://whatisthor.com) (can be omited with --no-executable)
- test infrastructure based on minitest and minitest-reporters
- release to rubygems.org or to private geminabox gem server
- optionaly create rails plugin gem with (mountable) engine
- readme with badges for coveralls, etc. for public projects (like the badges you see above)


## Installation

    $ gem install creategem


## Syntax
`Creategem` has 3 subcommands `gem`, `help` and `plugin`:

  $ creategem gem GEM_NAME [--private] [--no-executable] [--bitbucket]

  # Describe available commands or one subcommand
  $ creategem help [COMMAND]

  # Create a new Rails plugin with the given NAME:
  $ creategem plugin NAME [OPTIONS]
  # OPTIONS are: --private (Geminabox), --executable, --engine, --mountable, --bitbucket

When invoked without any options,
it is assumed that you want a gem with an executable,
and hosted on a public github git repository, and released to rubygems.org.

if your user name is not already stored in your git global config,
you will be asked for your GitHub or BitBucket user name.
You will also be asked to enter your GitHub or BitBucket password when the remote repository is created for you.

When you use the `--private` option the remote repository is made private,
and on release the gem will be pushed to a private Geminabox server.

By default the scaffold gem is created with an executable based on Thor,
but you can omit the executable with the option `--no-executable`.

After you create the gem, edit the `gemspec` and change the summary and the description.
Then commit the changes to git and invoke `rake release_patch`,
and your gem will be published.


    $ creategem plugin GEM_NAME [--engine] [--mountable] [--private] [--executable]

`creategem plugin` creates a rails plugin. You can also specify if the plugin should be an engine (`--engine`) or a mountable engine (`--mountable`).


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, run one of the following:
```shell
bundle exec rake release_patch
bundle exec rake release_minor
bundle exec rake release_major
```
The above will create a git tag for the version,
push git commits and tags,
and push the `.gem` file to https://rubygems.org.


## Contributing

Bug reports and pull requests are welcome on Github at https://github.com/igorj/creategem.
