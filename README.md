# Creategem

[![Gem Version](http://img.shields.io/gem/v/creategem.svg)][gem]

`Creategem` creates a scaffold project for a new gem together with remote repository (GitHub or Bitbucket)
that is ready to be released to a public or private gem server.

This project was inspired by the [Bundler](http://bundler.io)'s `bundle gem` subcommand,
and by [Deveoping a RubyGem using Bundler](https://github.com/radar/guides/blob/master/gem-development.md).

Similar to what Bundler's `bundle gem` command does,
this gem generates a scaffold with all files you need to start,
with the following additional features:

- Generates a README with badges.
- Automatically creates local and remote git repositories (on GitHub or BitBucket) for your gem.
- Remote repositories can be private or public.
- Creates an executable based on [Thor](http://whatisthor.com) (can be omited with `--no-executable`).
- Creates a test infrastructure based on `minitest` and `minitest-reporters`.
- Ready to publicly release to rubygems.org or to a private Geminabox gem server.
- Optionally create the gem as a:
  - A Rails plugin, possibly with a mountable engine.
  - A Jekyll plugin (tag, block tag, or generator).


## Installation

    $ gem install creategem


## Syntax
`Creategem` has 4 subcommands `gem`, `help`, `jekyll` and `plugin`:

**The `help` subcommand** lists the available subcommands,
or provides detail for the specified subcommand.

    $ creategem help [COMMAND]

**The `gem` subcommand** creates a scaffold for a gem within the `generated/` directory:

    $ creategem gem GEM_NAME [--private] [--no-executable] [--bitbucket]

When invoked without any options,
it is assumed that you want a gem with an executable,
and hosted on a public github git repository, and released to rubygems.org.

If your user name is not already stored in your git global config,
you will be asked for your GitHub or BitBucket user name.
You will also be asked to enter your GitHub or BitBucket password when the remote repository is created for you.

When you use the `--private` option the remote repository is made private,
and on release the gem will be pushed to a private Geminabox server.

By default the scaffold gem is created with an executable based on Thor,
but you can omit the executable with the option `--no-executable`.

After you create the gem, edit the `gemspec` and change the summary and the description.
Then commit the changes to git and invoke `rake release`,
and your gem will be published.


**The `jekyll` subcommand** extends the `gem` command and creates a new Jekyll plugin with the given NAME:

    $ creategem jekyll NAME [OPTIONS]

OPTIONS are:

    --private, --type, --bitbucket

The `--type` option must be used, and requires one of the following values: `tag`, `block`, or `generator`.



**The `plugin` subcommand** extends the `gem` command and creates a new Rails plugin with the given NAME:

    $ creategem plugin NAME [OPTIONS]

OPTIONS are:

    --private, --executable, --engine, --mountable, --bitbucket

You can specify if the plugin should be an engine (`--engine`) or a mountable engine (`--mountable`).


## Did It Work?
The following command shows all files that have been committed to the newly created git repository:

```shell
$ git ls-tree --name-only --full-tree -r HEAD
.envrc
.gitignore
.simplecov
.travis.yml
.vscode/launch.json
.vscode/settings.json
CHANGELOG.md
Gemfile
LICENCE.txt
README.md
Rakefile
bin/console
bin/rake
bin/setup
lib/x.rb
lib/x/version.rb
test/test_helper.rb
test/x_test.rb
x.gemspec
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, run:
```shell
$ bundle exec rake release
```
The above will create a git tag for the version,
push git commits and tags,
and push the `.gem` file to https://rubygems.org.


## Contributing

Bug reports and pull requests are welcome on Github at https://github.com/igorj/creategem.
