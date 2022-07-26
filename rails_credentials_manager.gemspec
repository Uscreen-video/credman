require_relative "lib/rails_credentials_manager/version"

Gem::Specification.new do |spec|
  spec.name = "rails_credentials_manager"
  spec.version = RailsCredentialsManager::VERSION
  spec.authors = ["Sergey Andronov"]
  spec.email = ["dev@uscreen.tv"]

  spec.summary = "The tool what you miss for managing Rails credentials"
  spec.description = "The tool what you miss for managing Rails credentials"
  spec.homepage = "https://github.com/Uscreen-video/rails_credentials_manager"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.executables = %w[rails_credentials_manager rcm]
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency "dry-cli", "~> 0.7"
  spec.add_dependency "tty-command", "~> 0.10"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "hash_diff", "~> 1.0"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.13"
end
