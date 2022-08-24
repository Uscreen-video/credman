require "tty-command"

module Credman
  class Diff < Credman::Base
    def perform(branch_to_compare)
      cmd = TTY::Command.new(pty: true, printer: :null)

      configs.each do |env, config|
        puts pastel.green("#{env}:")

        result = cmd.run!("echo `git show origin/#{branch_to_compare}:config/credentials/#{env}.yml.enc`")
        encripted_file_content = result.out.strip

        if encripted_file_content.blank?
          puts "❗️ Can not find #{env} credentials file in origin/#{branch_to_compare} branch"
          next
        end
        branch_config = config_to_compare_for(env, encripted_file_content)

        deep_print_diff(HashDiff.diff(branch_config, config))
      end
    end

    private

    def config_to_compare_for(environment, encripted_file_content)
      deserialize(decript(key_for(environment), encripted_file_content)).deep_symbolize_keys
    end

    def key_for(environment)
      Pathname.new("config/credentials/#{environment}.key").binread.strip
    end

    def decript(key, content)
      ActiveSupport::MessageEncryptor.new([key].pack("H*"), cipher: "aes-128-gcm")
        .decrypt_and_verify(content)
    end

    def deserialize(raw_config)
      # rubocop:disable Security/YAMLLoad
      YAML.respond_to?(:unsafe_load) ? YAML.unsafe_load(raw_config) : YAML.load(raw_config)
      # rubocop:enable Security/YAMLLoad
    end

    def deep_print_diff(diff, key_path = [])
      if diff.empty?
        puts pastel.green "\t✅ No differences"
        return
      end

      diff.each do |current_key, values|
        if values.is_a?(Hash)
          values.each { |k, val| deep_print_diff({k => val}, key_path + [current_key]) }
        elsif values.is_a?(Array)
          prev_value, current_value = values
          print_diff_row(key_path + [current_key], prev_value, current_value)
        end
      end
    end

    def print_diff_row(key_path, prev_value, current_value)
      if prev_value == HashDiff::NO_VALUE
        if current_value.is_a?(Hash)
          current_value.each { |value_key, value| print_diff_row(key_path + [value_key], prev_value, value) }
        else
          puts pastel.bright_green("\t#{key_path.join(".")}:\t ADDED: #{current_value.inspect}")
        end
      elsif current_value == HashDiff::NO_VALUE
        if prev_value.is_a?(Hash)
          prev_value.each { |value_key, value| print_diff_row(key_path + [value_key], value, current_value) }
        else
          puts pastel.bright_red("\t#{key_path.join(".")}:\tREMOVED: was #{prev_value.inspect}")
        end
      else # Changed
        puts pastel.bright_cyan("\t#{key_path.join(".")}:\tCHANGED: #{prev_value.inspect} => #{current_value.inspect}")
      end
    end
  end
end
