require "yaml"

module Credman
  class Configuration
    include Singleton

    @@settings_list = []

    def self.add_setting(name, default_value = nil)
      attr_accessor name
      instance.send("#{name}=", default_value)
      @@settings_list.push(name.to_sym)
    def self.reset
      load __FILE__
      self
    end

    def settings_list
      @@settings_list
    end

    def setting_exists?(setting_name)
      settings_list.include?(setting_name)
    end

    def load_from_yml(config_path = "config/credman.yml")
      return unless File.exist?(config_path)

      settings = YAML.load_file(config_path)
      return unless settings

      settings.each do |setting_name, setting_value|
        send("#{setting_name}=", setting_value) if setting_exists?(setting_name.to_sym)
      end
    end

    add_setting :default_diff_branch, "main"
    add_setting :available_environments, %w[development test production]
  end
end
