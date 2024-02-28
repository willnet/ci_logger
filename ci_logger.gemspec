require_relative "lib/ci_logger/version"

Gem::Specification.new do |spec|
  spec.name        = "ci_logger"
  spec.version     = CiLogger::VERSION
  spec.authors     = ["willnet"]
  spec.email       = ["netwillnet@gmail.com"]
  spec.homepage    = "https://github.com/willnet/ci_logger"
  spec.summary     = "Faster logger for CI"
  spec.description = "Faster logger for CI"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/willnet/ci_logger"
  spec.metadata["changelog_uri"] = "https://github.com/willnet/ci_logger"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.required_ruby_version = ">= 2.7.0"
  spec.add_dependency "railties", ">= 6.1.0"
  spec.add_development_dependency "rspec-rails"
end
