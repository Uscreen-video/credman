require "active_support/encrypted_file"

module Credman
  class Conflicts < Credman::Base
    REGEXP = /^<{7} HEAD(\r?\n(?!={7}\r?\n).*)*\r?\n={7}(\r?\n(?!>{7} ).*)*\r?\n>{7} \S+/m

    def perform
      @environment_list.each do |env|
        puts pastel.green("#{env}:")
        cred_content = File.read("config/credentials/#{env}.yml.enc")
        parsed_conflict = REGEXP.match(cred_content)

        unless parsed_conflict
          puts "✅ No conflicts found"
          next
        end

        our_config = config_to_compare_for(env, parsed_conflict[1].strip)
        their_config = config_to_compare_for(env, parsed_conflict[2].strip)
        @merged_config = our_config.deep_merge(their_config)
        deep_print_diff(HashDiff.diff(their_config, our_config))

        rewrite_config_for(env, @merged_config)
        puts "✅ Merged config for #{env} has been saved"
      end
    end

    private

    def config_to_compare_for(environment, encripted_file_content)
      deserialize(decript(key_for(environment), encripted_file_content)).deep_symbolize_keys
    end

    def deserialize(raw_config)
      YAML.respond_to?(:unsafe_load) ? YAML.unsafe_load(raw_config) : YAML.safe_load(raw_config)
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
          puts "\tADDED #{pastel.cyan("THEIR")} new key #{pastel.blue(key_path.join("."))}: #{pastel.yellow(current_value.inspect)}"
        end
      elsif current_value == HashDiff::NO_VALUE
        if prev_value.is_a?(Hash)
          prev_value.each { |value_key, value| print_diff_row(key_path + [value_key], value, current_value) }
        else
          puts "\tADDED #{pastel.cyan("OUR")} new key #{pastel.blue(key_path.join("."))}: #{pastel.yellow(prev_value.inspect)}"
        end
      else # Changed
        puts "\t❗️ The key #{pastel.blue(key_path.join("."))} changed in both branches, their: #{pastel.yellow(prev_value.inspect)}, our: #{pastel.yellow(current_value.inspect)}"
        puts "Which one should we use? Please type `their` or `our` to apply particular change or enter to abort."
        print "> "
        value_to_use = $stdin.gets.chomp
        merge_input_handler(value_to_use, key_path, prev_value, current_value)
      end
    end

    def merge_input_handler(input_value, key_path, their, our)
      if input_value == "their"
        deep_set!(@merged_config, key_path, their)
        puts "✅ #{pastel.blue(key_path.join("."))} set as #{pastel.yellow(their.inspect)}"
      elsif input_value == "our"
        deep_set!(@merged_config, key_path, our)
        puts "✅ #{pastel.blue(key_path.join("."))} set as #{pastel.yellow(our.inspect)}"
      else
        abort("❌ Merge aborted. Config did not save.")
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
  end
end
