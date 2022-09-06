require "spec_helper"

RSpec.describe Credman::Delete do
  describe "#perform" do
    subject(:perform) { described_class.new(envs).perform(keys) }

    let(:envs) { %w[development test staging production] }

    context "with no keys provided" do
      let(:keys) { [] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/At least one key required/).to_stderr
      end
    end

    context "with no enviroments provided" do
      let(:keys) { [] }
      let(:envs) { [] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "with no valid environments" do
      let(:envs) { %w[dev prod] }
      let(:keys) { ["something"] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "with valid config" do
      let(:configs) do
        {
          development: {existing: {key: "dev_val"}},
          test: {existing: {key: "test_val"}},
          staging: {existing: {key: nil}},
          production: {}
        }
      end

      before do
        allow_any_instance_of(described_class).to receive(:configs).and_return(configs)
        allow_any_instance_of(ActiveSupport::EncryptedConfiguration).to receive(:write).and_return(true)
      end

      context "with non-existing key" do
        let(:keys) { ["non_existing.key"] }

        it "shows key not found message" do
          regexp = [
            "development:", "non_existing.key:", "key not found, can't delete",
            "test:", "non_existing.key:", "key not found, can't delete",
            "staging:", "non_existing.key:", "key not found, can't delete",
            "production:", "non_existing.key:", "key not found, can't delete"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
        end
      end

      context "with existing key" do
        let(:keys) { ["existing.key"] }

        it "prints values for every environments" do
          regexp = [
            "development:", "existing.key:", "deleted",
            "test:", "existing.key:", "deleted",
            "staging:", "existing.key:", "deleted",
            "production:", "existing.key:", "key not found, can't delete"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
        end
      end

      context "with multiple keys" do
        let(:keys) { ["existing.key", "wrong_key"] }

        it "prints values for every environments" do
          regexp = [
            "development:", "existing.key:", "deleted", "wrong_key:", "key not found, can't delete",
            "test:", "existing.key:", "deleted", "wrong_key:", "key not found, can't delete",
            "staging:", "existing.key:", "deleted", "wrong_key:", "key not found, can't delete",
            "production:", "existing.key:", "key not found, can't delete", "wrong_key:", "key not found, can't delete"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
        end
      end
    end
  end
end
