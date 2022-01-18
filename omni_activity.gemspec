$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "omni_activity/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "omni_activity"
  spec.version     = OmniActivity::VERSION
  spec.authors     = ["Andersen Fan"]
  spec.email       = ["as181920@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Common activity tracking"
  spec.description = "Save user activities"
  spec.license     = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://gems.io-note.cn"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.1"

  spec.add_development_dependency "sqlite3"
end
