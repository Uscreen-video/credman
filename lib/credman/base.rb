module Credman
  class Base
    def initialize(environment_list)
      @environment_list = environment_list.keep_if { |env| env.in?(Credman.config.available_environments) }
      abort pastel.red("No valid environments specified. Valid example: `-e development,test`") if @environment_list.empty?
    end

    def configs
      @configs ||= @environment_list.inject({}) { |conf, env| conf.merge({env => config_for(env)}) }
    end

    def pastel
      @pastel ||= Pastel.new
    end

    def print_key_and_value(key, value)
      print pastel.blue("\t#{key}:\t")

      case value
      when "not set"
        print pastel.red("not set")
      when ->(v) { v.is_a?(String) }
        print pastel.yellow(value)
      else
        print pastel.yellow(value.inspect)
      end

      print "\n"
    end

    def config_has_keys?(config, keys_path)
      dig_keys = keys_path[0...-1]
      return config.key?(keys_path.first) if dig_keys.empty?

      config.dig(*dig_keys)&.key?(keys_path.last)
    end

    def rewrite_config_for(environment, new_config)
      # removes "---\n" in the very beginning
      config_as_string = new_config.deep_stringify_keys.to_yaml[4..]

      encrypted_configuration(environment).write(config_as_string)
    end

    def key_for(environment)
      if op_available?
        key = load_key_from_onepassword(environment)
        return key if key
      end

      # Fallback to original behavior: read from file
      Pathname.new("config/credentials/#{environment}.key").binread.strip
    end

    def decript(key, content)
      ActiveSupport::MessageEncryptor.new([key].pack("H*"), cipher: "aes-128-gcm")
        .decrypt_and_verify(content)
    end

    private

    def op_available?
      @op_available ||= system('which op > /dev/null 2>&1')
    end

    def map_env_to_vault(env)
      env.to_s.capitalize
    end

    def load_key_from_onepassword(environment)
      vault = map_env_to_vault(environment)
      secret_ref = "op://#{vault}/RAILS_MASTER_KEY/password"

      # Use op read to get the secret
      result = `op read "#{secret_ref}" 2>&1`.strip

      # Check if command was successful
      if $?.success? && !result.empty? && !result.include?('error')
        result
      else
        nil
      end
    rescue StandardError => e
      # Silently fail and fall back to file-based key
      nil
    end

    def config_for(environment)
      encrypted_configuration(environment).config
    end

    def encrypted_configuration(environment)
      ActiveSupport::EncryptedConfiguration.new(
        config_path: "config/credentials/#{environment}.yml.enc",
        key_path: "config/credentials/#{environment}.key",
        env_key: "RAILS_MASTER_KEY",
        raise_if_missing_key: true
      )
    end
  end
end
