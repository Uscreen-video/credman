module Credman
  class Delete < Credman::Base
    def perform(keys)
      abort pastel.red("At least one key required") if keys.empty?

      configs.each do |env, config|
        puts pastel.green("#{env}:")

        updated_config = config.dup
        is_updated = false

        keys_with_path = keys.index_with { |key| key.split(".").map(&:to_sym) }
        keys_with_path.each do |full_key, key_path|
          if config_has_keys?(config, key_path)
            is_updated ||= true
            deep_delete!(updated_config, key_path)
            print pastel.blue("\t#{full_key}:\t"), pastel.green("✅ deleted\n")
          else
            print pastel.blue("\t#{full_key}:\t"), pastel.red("❌ key not found, can't delete\n")
          end
        end

        if is_updated
          # removes "---\n" in the very beginning
          config_as_string = updated_config.deep_stringify_keys.to_yaml[4..]
          rewrite_config_for(env, config_as_string)
        end
      end
    end

    def rewrite_config_for(environment, new_config)
      ActiveSupport::EncryptedConfiguration.new(
        config_path: "config/credentials/#{environment}.yml.enc",
        key_path: "config/credentials/#{environment}.key",
        env_key: "RAILS_MASTER_KEY",
        raise_if_missing_key: true
      ).write(new_config)
    end

    def deep_delete!(obj, keys)
      key = keys.first
      if keys.length == 1
        obj.delete(key)
      else
        obj[key] = {} unless obj[key]
        deep_delete!(obj[key], keys.slice(1..-1))
      end
    end

    def normalize_new_value(new_value)
      return if new_value.in?(%w[nil null])

      new_value
    end
  end
end
