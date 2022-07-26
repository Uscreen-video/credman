require "active_support"
require "active_support/core_ext"
require "active_support/encrypted_configuration"
require "dry/cli"
require "pastel"
require "hash_diff"

require_relative "rails_credentials_manager/base"
require_relative "rails_credentials_manager/commands"
require_relative "rails_credentials_manager/get"
require_relative "rails_credentials_manager/list"
require_relative "rails_credentials_manager/set"
require_relative "rails_credentials_manager/diff"
require_relative "rails_credentials_manager/conflicts"
require_relative "rails_credentials_manager/version"

module RailsCredentialsManager
  module CLI
    module Commands
      extend Dry::CLI::Registry

      register "get", Get
      register "list", List
      register "set", Set
      register "diff", Diff
      register "conflicts", Conflicts
    end
  end
end
