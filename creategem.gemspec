require_relative 'lib/creategem/version'

Gem::Specification.new do |spec|
  spec.authors       = ["Igor Jancev", "Mike Slinn"]
  spec.bindir        = "exe"
  spec.email         = ["igor@masterybits.com", "mslinn@mslinn.com"]
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  spec.description   = %q{Creategem creates a scaffold project for new gems. You can choose between Github and Bitbucket,
                          Rubygems or Geminabox, with executable or without, etc.}
  spec.homepage      = "https://github.com/igorj/creategem"
  spec.license       = "MIT"
  spec.name          = "creategem"
  spec.require_paths = ["lib"]
  spec.summary       = %q{Creategem creates a scaffold project for new gems}
  spec.version       = Creategem::VERSION

  spec.add_dependency "git"
  spec.add_dependency "thor"
end
