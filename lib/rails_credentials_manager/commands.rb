module RailsCredentialsManager
  module CLI
    module Commands
      class Get < Dry::CLI::Command
        desc "Find keys in credentials files for each environment"

        argument :keys, type: :array, required: true, desc: "keys to show"

        option :environments,
          aliases: ["e"],
          type: :array,
          default: RailsCredentialsManager::Base::AVAILABLE_ENVIRONMENTS,
          desc: "filter for environments"

        def call(keys:, environments:, **)
          RailsCredentialsManager::Get.new(environments).perform(keys)
        end
      end

      class List < Dry::CLI::Command
        desc "List of all keys for each environment"

        option :environments,
          aliases: ["e"],
          type: :array,
          default: RailsCredentialsManager::Base::AVAILABLE_ENVIRONMENTS,
          desc: "filter for environments"

        def call(environments:, **)
          RailsCredentialsManager::List.new(environments).perform
        end
      end

      class Set < Dry::CLI::Command
        desc "Set a value to the key provided for given environments"

        argument :key, type: :string, required: true
        argument :value, type: :string, required: true

        option :environments,
          aliases: ["e"],
          type: :array,
          default: [],
          desc: "filter for environments"

        def call(key:, value:, environments:, **)
          RailsCredentialsManager::Set.new(environments).perform(key, value)
        end
      end

      class Diff < Dry::CLI::Command
        desc "Show credentials diff between given branch (heroku by default) and current changes"

        argument :branch, type: :string, default: "heroku", required: false

        option :environments,
          aliases: ["e"],
          type: :array,
          default: RailsCredentialsManager::Base::AVAILABLE_ENVIRONMENTS,
          desc: "filter for environments"

        def call(branch:, environments:, **)
          RailsCredentialsManager::Diff.new(environments).perform(branch)
        end
      end

      class Conflicts < Dry::CLI::Command
        desc "Help to resolve merge conflicts for credentials"

        option :environments,
          aliases: ["e"],
          type: :array,
          default: RailsCredentialsManager::Base::AVAILABLE_ENVIRONMENTS,
          desc: "filter for environments"

        def call(environments:, **)
          RailsCredentialsManager::Conflicts.new(environments).perform
        end
      end
    end
  end
end
