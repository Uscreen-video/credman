require "spec_helper"

RSpec.describe Credman::Set do
  describe "#perform" do
    subject(:perform) { described_class.new(envs).perform(key, value) }

    let(:envs) { %w[rspec] }
    let(:key) { "any" }
    let(:value) { "any" }

    before do
      stub_const("ENV", {"RAILS_MASTER_KEY" => "6c572cf4c3606c058ba95c8a9df292ce"})
      allow_any_instance_of(Credman::Configuration).to receive(:available_environments).and_return(%w[rspec])
    end

    context "with empty key and value" do
      let(:key) { "" }
      let(:value) { "" }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/Invalid key/).to_stderr
      end
    end

    context "with no enviroments provided" do
      let(:envs) { [] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "with no valid environments" do
      let(:envs) { %w[dev prod] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "with valid environment" do
      let(:instance) { described_class.new(envs) }

      before { FileUtils.cp("spec/fixtures/credentials_sample.yml.enc", "config/credentials/rspec.yml.enc") }
      after { FileUtils.rm "config/credentials/rspec.yml.enc" }

      context "with root key" do
        let(:key) { "new_root_key" }

        it "adds a new root key with a value" do
          regexp = [
            "rspec:",
            "new_root_key:", "ADDED: any"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
          expect(instance.configs).to eq "rspec" => {aws: {access_key_id: 123, secret_access_key: 345}, new_key: "new_value", new_root_key: "any"}
        end
      end

      context "with nested key" do
        let(:key) { "new.nested.key" }

        it "adds a new root key with a value" do
          regexp = [
            "rspec:",
            "new.nested.key:", "ADDED: any"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
          expect(instance.configs).to eq "rspec" => {aws: {access_key_id: 123, secret_access_key: 345}, new: {nested: {key: "any"}}, new_key: "new_value"}
        end
      end

      context "change existing key" do
        let(:key) { "aws.access_key_id" }

        it "adds a new root key with a value" do
          regexp = [
            "rspec:",
            "aws.access_key_id:", 'CHANGED: "any"; previous value: 123'
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
          expect(instance.configs).to eq "rspec" => {aws: {access_key_id: "any", secret_access_key: 345}, new_key: "new_value"}
        end
      end

      context "change existing key to the same value" do
        let(:key) { "aws.access_key_id" }
        let(:value) { 123 }

        it "adds a new root key with a value" do
          regexp = [
            "rspec:",
            "aws.access_key_id:", "NOT CHANGED. The value already the same: 123"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
          expect(instance.configs).to eq "rspec" => {aws: {access_key_id: 123, secret_access_key: 345}, new_key: "new_value"}
        end
      end
    end
  end
end
