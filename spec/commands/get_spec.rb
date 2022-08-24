require "spec_helper"

RSpec.describe Credman::Get do
  describe "#perform" do
    subject(:perform) { described_class.new(envs).perform(keys) }

    let(:envs) { %w[development test staging production] }

    context "with no keys provided" do
      let(:keys) { [] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/At least one key required/).to_stderr
      end
    end

    context "with no valid environments" do
      let(:envs) { %w[dev prod] }
      let(:keys) { ["something"] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "with valid keys" do
      let(:configs) do
        {
          development: {existing: {key: "dev_val"}},
          test: {existing: {key: "test_val"}},
          staging: {existing: {key: nil}},
          production: {}
        }
      end

      before { allow_any_instance_of(described_class).to receive(:configs).and_return(configs) }

      context "with existing key" do
        let(:keys) { ["existing.key"] }

        it "prints values for every environments" do
          regexp = [
            "development:", "existing.key:", "dev_val",
            "test:", "existing.key:", "test_val",
            "staging:", "existing.key:", "nil",
            "production:", "existing.key:", "not set"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
        end
      end

      context "with multiple keys" do
        let(:keys) { ["existing.key", "wrong_key"] }

        it "prints values for every environments" do
          regexp = [
            "development:", "existing.key:", "dev_val", "wrong_key:", "not set",
            "test:", "existing.key:", "test_val", "wrong_key:", "not set",
            "staging:", "existing.key:", "nil", "wrong_key:", "not set",
            "production:", "existing.key:", "not set", "wrong_key:", "not set"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
        end
      end
    end
  end
end
