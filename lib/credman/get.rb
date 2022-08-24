module Credman
  class Get < Credman::Base
    def perform(keys)
      abort pastel.red("At least one key required") if keys.empty?

      keys_with_path = keys.index_with { |key| key.split(".").map(&:to_sym) }

      configs.each do |env, config|
        puts pastel.green("#{env}:")

        keys_with_path.each do |full_key, key_path|
          value = config_has_keys?(config, key_path) ? configs[env].dig(*key_path) : "not set"
          print_key_and_value(full_key, value)
        end
      end
    end
  end
end
