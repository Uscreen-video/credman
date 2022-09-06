require "spec_helper"

RSpec.describe Credman::List do
  describe "#perform" do
    subject(:perform) { described_class.new(envs).perform }

    let(:envs) { %w[development test staging production] }

    context "with no valid environments" do
      let(:envs) { %w[dev prod] }
      let(:keys) { ["something"] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "with valid configs" do
      let(:configs) do
        {
          development: {existing: {key: "dev_val"}, test: "123"},
          test: {existing: {key: "test_val"}},
          staging: {existing: {key: nil}},
          production: {}
        }
      end

      before { allow_any_instance_of(described_class).to receive(:configs).and_return(configs) }

      it "prints all values for every environments" do
        regexp = [
          "development:", "existing.key:", "dev_val", "test:", "123",
          "test:", "existing.key:", "test_val",
          "staging:", "existing.key:", "nil",
          "production:"
        ].join(".+")

        expect { perform }.to output(/#{regexp}/m).to_stdout
      end
    end
  end
end
