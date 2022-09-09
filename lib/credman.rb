require "active_support"
require "active_support/core_ext"
require "active_support/encrypted_configuration"
require "dry/cli"
require "pastel"
require "hash_diff"

require_relative "credman/configuration"
module Credman
  def self.configuration
    Credman::Configuration.instance
  end
  singleton_class.send(:alias_method, :config, :configuration)
end
Credman.configuration.load_from_yml

require_relative "credman/base"
require_relative "credman/commands"
require_relative "credman/get"
require_relative "credman/list"
require_relative "credman/set"
require_relative "credman/delete"
require_relative "credman/diff"
require_relative "credman/conflicts"
require_relative "credman/version"

module Credman
  module CLI
    module Commands
      extend Dry::CLI::Registry

      register "get", Get
      register "list", List
      register "set", Set
      register "delete", Delete
      register "diff", Diff
      register "conflicts", Conflicts
    end
  end
end
