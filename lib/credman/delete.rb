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

        rewrite_config_for(env, updated_config) if is_updated
      end
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
