require_relative "lib/credman/version"

Gem::Specification.new do |spec|
  spec.name = "credman"
  spec.version = Credman::VERSION
  spec.authors = ["Sergey Andronov"]
  spec.email = ["dev@uscreen.tv"]

  spec.summary = "The tool what you miss for managing Rails credentials"
  spec.description = "The tool what you miss for managing Rails credentials"
  spec.homepage = "https://github.com/Uscreen-video/credman"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Uscreen-video/credman/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.executables = "credman"
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency "dry-cli", "~> 0.7"
  spec.add_dependency "tty-command", "~> 0.10"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "hash_diff", "~> 1.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.13"
  spec.add_development_dependency "appraisal"
end
