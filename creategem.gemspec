require_relative 'lib/creategem/version'

Gem::Specification.new do |spec|
  spec.authors       = ['Igor Jancev', 'Mike Slinn']
  spec.bindir        = 'exe'
  spec.email         = ['igor@masterybits.com', 'mslinn@mslinn.com']
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  spec.description   = <<~END_DESC
    Creategem creates a scaffold project for new gems. You can choose between Github and Bitbucket,
    Rubygems or Geminabox, with or without an executable, etc.
  END_DESC
  spec.homepage      = 'https://github.com/mslinn/creategem'
  spec.license       = 'MIT'
  spec.name          = 'creategem'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.1.0'
  spec.summary       = 'Creategem creates a scaffold project for new gems.'
  spec.version       = Creategem::VERSION

  spec.add_dependency 'rugged'
  spec.add_dependency 'thor'
end
