module Credman
  class Base
    AVAILABLE_ENVIRONMENTS = %i[development test staging production].freeze

    def initialize(environment_list)
      @environment_list = environment_list.map(&:to_sym).keep_if { |env| env.to_sym.in?(AVAILABLE_ENVIRONMENTS) }
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

    private

    def config_for(environment)
      ActiveSupport::EncryptedConfiguration.new(
        config_path: "config/credentials/#{environment}.yml.enc",
        key_path: "config/credentials/#{environment}.key",
        env_key: "RAILS_MASTER_KEY",
        raise_if_missing_key: true
      ).config
    end
  end
end
