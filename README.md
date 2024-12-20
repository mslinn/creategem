# `Nugem` [![Gem Version](https://badge.fury.io/rb/nugem.svg)](https://badge.fury.io/rb/nugem)

`Nugem` creates a scaffold project for a new gem in a new git repository.
After you add your special code to the gem scaffold,
the project is ready to be released to a public or private gem server.

This gem generates a new working Visual Studio Code project with the following features:

- Compatible with `rbenv`.
- `Gemfile` and `.gemspec` files set up.
- Generates a README with badges.
- Visual Studio Code project is set up with current Ruby extensions.
  - Rubocop configured.
  - Shellcheck configured.
  - Markdown lint configured.
  - Launch configurations set up for testing.
- Can automatically create a public or private git repository on GitHub for your new gem.
- Creates a test infrastructure based on `rspec`.
- Your gem can be publicly released to `rubygems.org`.
- Optionally create the gem as:
  - A plain old gem.
  - A Jekyll plugin (tag or block tag).

The following features are still in development, so they probably do not work yet:

- Automatically creates git repositories on BitBucket or Geminabox.
- Creates a test infrastructure based on `minitest` and `minitest-reporters`.
- Your gem can be privately released to a Geminabox gem server.
- Your gem can include a [Thor-based executable](https://github.com/rails/thor).
- Optionally create the gem as:
  - A Jekyll plugin (filter, generator, or hooks).
  - A Rails plugin, possibly with a mountable engine.


## Installation

```shell
$ gem install nugem
```

If you are using [rbenv](https://github.com/rbenv/rbenv) to manage Ruby instances, type:

```shell
$ rbenv rehash
```

To update the program:

```shell
$ gem update nugem
```


## Subcommands and Options

`Nugem` has 4 subcommands `gem`, `jekyll`, `help` and `rails`.
Currently, only `gem`, `jekyll` and `help` have been properly tested.


### `help` Subcommand

The following lists the available subcommands:

```shell
$ nugem help
```

The following provides detailed help for the specified subcommand:

```shell
$ nugem help [SUBCOMMAND]
```


### Common Options

The `gem`, `jekyll` and `rails` subcommands have common options.

The default option values assume that:

- You do not want an executable for your gem scaffold
- The gem project will be hosted on a public GitHub git repository
- The gem will be released to `rubygems.org`

Common options for the `gem`, `jekyll` and `rails` subcommands are:

<dl>
  <dt><code>--executable</code></dt>
    <dd>add an executable based on Thor.</dd>

  <dt><code>--host</code></dt>
    <dd>
      specifies the git host; possible values are <code>bitbucket</code>,
      <code>github</code> and <code>geminabox</code>.
    </dd>

  <dt><code>--out_dir</code></dt>
    <dd>
      specifies the directory to write the generated gem to.
      The default is <code>generated/</code>.
    </dd>

  <dt><code>--private</code></dt>
    <dd>the remote repository is made private,
        and on release the gem will be pushed to a private Geminabox server.
    </dd>

  <dt><code>--quiet</code></dt>
    <dd>reduces verbosity.</dd>

  <dt><code>--no-todos</code></dt>
    <dd>do not generate `TODO:` strings in generated code.</dd>
</dl>


### Common Behavior

The `gem`, `jekyll` and `rails` subcommands have common behavior.

Gem scaffolds are created within the `generated/` directory of the current directory.

If your user name is not already stored in your git global config,
you will be asked for your GitHub or BitBucket user name.
You will also be asked to enter your GitHub or BitBucket password when the remote repository is created for you.

After you create the gem, edit the `gemspec` and change the summary and the description.
Then commit the changes to git and invoke `rake release`,
and your gem will be published.


### `gem` Subcommand

```shell
$ nugem gem NAME [COMMON_OPTIONS] [--test-framework=minitest|rspec]
```

`NAME` is the name of the gem to be generated.

The default test framework for the `gem` subcommand is `rspec`,
but you can specify `minitest` instead like this:

```shell
$ nugem gem my_gem --test-framework=minitest
```


### `jekyll` Subcommand

The `jekyll` subcommand extends the `gem` subcommand and creates a new Jekyll plugin with the given NAME:

```shell
$ nugem jekyll NAME [OPTIONS]
```

`NAME` is the name of the Jekyll plugin gem to be generated.

In addition to the common options, the `jekyll`-specific `OPTIONS` are:

`--block`, `--blockn`, `--filter`, `--hooks`, `--tag`, and `--tagn`.

(Warning: only `--block` and `--tag` been properly tested.)

Each of these options causes `nugem` to prompt the user for additional input.

The test framework for `jekyll` plugins is `rspec`.

All of the above options can be specified more than once, except the `--hooks` option.
For example:

```shell
$ nugem jekyll test_tags --tag my_tag1 --tag my_tag2
```

The above creates a Jekyll plugin called `test_tags`,
which defines Jekyll tags called `my_tag1` and `my_tag2`.
You might use these tags in an HTML document like this:

```html
<pre>
my_tag1 usage: {% my_tag1 %}
my_tag2 usage: {% my_tag2 %}
</pre>
```

For more information, type:

```shell
$ nugem help jekyll
```


### `rails` Subcommand

The `rails` subcommand extends the `gem` subcommand and creates a new Rails plugin with the given NAME:

```shell
$ nugem rails NAME [OPTIONS]
```

`NAME` is the name of the Ruby on Rails plugin gem to be generated.

In addition to the common options, `rails` `OPTIONS` are
`--engine` and `--mountable`.

You can specify if the plugin should be an engine (`--engine`) or a mountable engine (`--mountable`).

Each of these options causes `nugem` to prompt the user for additional input.

The test framework for `rails` gems is `minitest`.

For more information, type:

```shell
$ nugem help rails
```


## Did It Work?

The following shows all files that were committed to the newly created git repository,
after `nugem jekyll` finished making two tag blocks:

```shell
$ git ls-tree --name-only --full-tree -r HEAD
.envrc
.gitignore
.rspec
.rubocop.yml
.simplecov
.travis.yml
.vscode/extensions.json
.vscode/launch.json
.vscode/settings.json
CHANGELOG.md
Gemfile
LICENCE.txt
README.md
Rakefile
bin/attach
bin/console
bin/rake
bin/setup
demo/Gemfile
demo/_bin/debug
demo/_config.yml
demo/_drafts/2022/2022-05-01-test2.html
demo/_includes/block_tag_template_wrapper
demo/_layouts/default.html
demo/_posts/2022/2022-01-02-redact-test.html
demo/assets/css/style.css
demo/assets/images/404-error.png
demo/assets/images/404-error.webp
demo/assets/images/favicon.png
demo/assets/images/jekyll.png
demo/assets/images/jekyll.webp
demo/assets/js/clipboard.min.js
demo/assets/js/jquery-3.4.1.min.js
demo/blog/blogsByDate.html
demo/blog/index.html
demo/index.html
jekyll_test.code-workspace
jekyll_test.gemspec
lib/jekyll_test.rb
lib/jekyll_test/version.rb
lib/my_block1.rb
lib/my_block2.rb
spec/jekyll_test_spec.rb
spec/spec_helper.rb
test/jekyll_test_test.rb
test/test_helper.rb
```


## Visual Studio Code Support

### Nugem Project

#### Plugins

If you have not installed the
[Snippets](https://marketplace.visualstudio.com/items?itemName=devonray.snippet) extension,
Visual Studio Code will suggest that you do so the first time you open this project with Visual Studio Code.
You can also review the list of suggested extensions of with the <kbd>Ctrl</kbd>-<kbd>P</kbd>
`Extensions: Show Recommended Extensions` command.

#### Snippets

The predefined snippets for `nugem` are defined in
[`.vscode/nugem.json.code-snippets`](.vscode/nugem.json.code-snippets).
These snippets are focused on maintaining `nugem` itself.

#### File Associations

`.vscode/settings.json` defines file associations for various flavors of Thor templates in the `"files.associations"` section.
You can disable them by commenting some or all of those definitions.


### Generated Projects


#### Plugins

Similarly, for each gem project generated by `nugem`, Visual Studio Code will suggest
the user install missing extensions the first time those projects are opened.


#### Snippets

The predefined snippets for gem projects generated by `nugem` are defined in
their `.vscode/gem.json.code-snippets` file.
These snippets are focused on writing Jekyll plugins.


## Development

After checking out the repository, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run:

```shell
$ bundle exec rake install
```

To release a new version, run:

```shell
$ bundle exec rake release
```

The above will create a git tag for the version, push git commits and tags,
and push the `.gem` file to https://rubygems.org.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mslinn/nugem.


## See Also

- [`gem-release`](https://rubygems.org/gems/gem-release)
- [`bundle gem`](https://bundler.io/v2.4/man/bundle-gem.1.html)
- [Deveoping a RubyGem using Bundler](https://bundler.io/guides/creating_gem.html)
