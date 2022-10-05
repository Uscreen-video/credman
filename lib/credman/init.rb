module Credman
  class Init
    attr_reader :config_path

    def initialize
      @config_path = "config/credman.yml"
    end

    def perform(force_rewrite)
      if config_exists? && !force_rewrite
        abort "[SKIPPED] config/credman.yml already exist. You can run with `--force-rewrite` option to rewrite it"
      end

      save_config(available_environments: available_environments, default_diff_branch: default_diff_branch)
    end

    private

    def config_exists?
      File.exist?(config_path)
    end

    def save_config(**options)
      File.write(config_path, config_file_content(options))
    end

    def config_file_content(available_environments:, default_diff_branch:)
      <<~YML
        default_diff_branch: #{default_diff_branch}
        available_environments:
        #{available_environments.map { |env| "  - " + env }.join("\n")}
      YML
    end

    def default_diff_branch
      base_branch = `git remote show origin | sed -n '/HEAD branch/s/.*: //p'`.strip
      "origin/#{base_branch}"
    end

    def available_environments
      Dir.glob("./config/credentials/*.yml.enc").map { |filepath| File.basename(filepath, ".yml.enc") }
    end
  end
end
