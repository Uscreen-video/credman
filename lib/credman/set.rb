module Credman
  class Set < Credman::Base
    def perform(key, new_value)
      key_with_path = key.split(".").map(&:to_sym)
      new_value = normalize_new_value(new_value)

      configs.each do |env, config|
        puts pastel.green("#{env}:")
        update_config = true

        if config_has_keys?(config, key_with_path)
          previous_value = configs[env].dig(*key_with_path)
          if previous_value == new_value
            value = "NOT CHANGED. The value already the same: #{new_value.inspect}"
            update_config = false
          else
            value = "CHANGED: #{new_value.inspect}; previous value: #{previous_value.inspect}"
          end
        else
          value = "ADDED: #{new_value}"
        end

        print_key_and_value(key, value)

        if update_config
          updated_config = config.dup
          deep_set!(updated_config, key_with_path, new_value)
          rewrite_config_for(env, updated_config)
        end
      end
    end

    def deep_set!(obj, keys, value)
      key = keys.first
      if keys.length == 1
        obj[key] = value
      else
        obj[key] = {} unless obj[key]
        deep_set!(obj[key], keys.slice(1..-1), value)
      end
    end

    def normalize_new_value(new_value)
      return if new_value.in?(%w[nil null])

      new_value
    end
  end
end
