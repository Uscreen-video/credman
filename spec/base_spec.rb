require "spec_helper"

RSpec.describe Credman::Base do
  describe "#configs" do
    subject(:perform) { described_class.new(environment_list).configs }

    context "when environment_list is empty" do
      let(:environment_list) { [] }

      it "raise an error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "when environment_list has invalid values" do
      let(:environment_list) { %w[invalid something] }

      it "raise an error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "when environment_list has a valid value" do
      let(:environment_list) { %w[development] }

      it "gets decrypted config using ActiveSupport::EncryptedConfiguration" do
        expect(ActiveSupport::EncryptedConfiguration).to receive(:new)
          .with(
            config_path: "config/credentials/development.yml.enc",
            key_path: "config/credentials/development.key",
            env_key: "RAILS_MASTER_KEY",
            raise_if_missing_key: true
          ).once.and_return(double(config: {example: "value"}))

        is_expected.to eq "development" => {example: "value"}
      end
    end

    context "when environment_list has valid values" do
      let(:environment_list) { %w[development test] }

      it "gets decrypted config using ActiveSupport::EncryptedConfiguration" do
        expect(ActiveSupport::EncryptedConfiguration).to receive(:new)
          .with(
            config_path: "config/credentials/development.yml.enc",
            key_path: "config/credentials/development.key",
            env_key: "RAILS_MASTER_KEY",
            raise_if_missing_key: true
          ).once.and_return(double(config: {example: "development value"}))

        expect(ActiveSupport::EncryptedConfiguration).to receive(:new)
          .with(
            config_path: "config/credentials/test.yml.enc",
            key_path: "config/credentials/test.key",
            env_key: "RAILS_MASTER_KEY",
            raise_if_missing_key: true
          ).once.and_return(double(config: {example: "test value"}))

        is_expected.to eq "development" => {example: "development value"}, "test" => {example: "test value"}
      end
    end
  end

  describe "#rewrite_config_for" do
    subject(:perform) { described_class.new(environment_list).rewrite_config_for(environment, new_config) }

    let(:environment) { environment_list.first }
    let(:new_config) { {example: "value", nested: {key: "nested value"}} }

    context "when environment_list has a valid value" do
      let(:environment_list) { %w[development] }

      it "gets decrypted config using ActiveSupport::EncryptedConfiguration" do
        encrypted_file_instance = double(write: true)
        expect(ActiveSupport::EncryptedConfiguration).to receive(:new)
          .with(
            config_path: "config/credentials/development.yml.enc",
            key_path: "config/credentials/development.key",
            env_key: "RAILS_MASTER_KEY",
            raise_if_missing_key: true
          ).once.and_return(encrypted_file_instance)
        expect(encrypted_file_instance).to receive(:write)
          .with("example: value\nnested:\n  key: nested value\n").and_return(true)

        is_expected.to be true
      end
    end
  end

  context "real write and read of a config" do
    subject(:perform) do
      base_class.rewrite_config_for(environment, config_to_write)
      base_class.configs
    end

    let(:base_class) { described_class.new([environment]) }
    let(:environment) { "rspec" }
    let(:config_to_write) { {example: "value", nested: {key: "nested value"}} }
    let(:config_file_path) { "config/credentials/rspec.yml.enc" }

    before do
      allow_any_instance_of(Credman::Configuration).to receive(:available_environments).and_return([environment])
      stub_const("ENV", {"RAILS_MASTER_KEY" => SecureRandom.hex})
    end
    after { File.delete(config_file_path) if File.exist?(config_file_path) }

    it "configs must be the same" do
      is_expected.to eq environment => config_to_write
    end
  end
end
