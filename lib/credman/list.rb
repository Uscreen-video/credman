module Credman
  class List < Credman::Base
    def perform
      configs.each do |env, config|
        puts pastel.green("#{env}:")

        config.each do |key, value|
          if value.is_a?(Hash)
            key_path = [key]
          else
            value = {key => value}
            key_path = []
          end

          deep_print_key_and_value(value, key_path)
        end
      end
    end

    private

    def deep_print_key_and_value(object, key_path)
      object.each do |current_key, value|
        if value.is_a?(Hash)
          value.each { |k, val| deep_print_key_and_value({k => val}, key_path + [current_key]) }
        else
          full_key = (key_path + [current_key]).join(".")
          print_key_and_value(full_key, value)
        end
      end
    end
  end
end
