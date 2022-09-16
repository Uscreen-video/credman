require "spec_helper"

RSpec.describe Credman::Diff do
  describe "#perform" do
    subject(:perform) { described_class.new(envs).perform(branch) }

    let(:envs) { %w[development test] }
    let(:branch) { nil }

    context "with no valid environments" do
      let(:envs) { %w[dev prod] }

      it "shows error" do
        expect { perform }.to raise_error(SystemExit).and output(/No valid environments specified. Valid example: `-e development,test`/).to_stderr
      end
    end

    context "with valid environments" do
      let(:configs) do
        {
          development: {added: {key: "dev_val"}, new_key: "new_dev_value"},
          test: {added: {key: "test_val"}, new_key: "new_test_value"}
        }
      end

      before { allow_any_instance_of(described_class).to receive(:configs).and_return(configs) }

      context "with non existing branch" do
        let(:branch) { "non-existing-branch" }

        it "prints values for every environments" do
          regexp = [
            "development:", "Can not find development credentials file in non-existing-branch branch",
            "test:", "Can not find test credentials file in non-existing-branch branch"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
        end
      end

      context "with existing branch" do
        let(:branch) { "existing-branch" }

        before do
          stub_const("ENV", {"RAILS_MASTER_KEY" => "6c572cf4c3606c058ba95c8a9df292ce"})
          allow_any_instance_of(TTY::Command).to receive(:run!)
            .with("echo `git show existing-branch:config/credentials/development.yml.enc`")
            .and_return(double(out: File.read("spec/fixtures/credentials_sample.yml.enc")))
          allow_any_instance_of(TTY::Command).to receive(:run!)
            .with("echo `git show existing-branch:config/credentials/test.yml.enc`")
            .and_return(double(out: File.read("spec/fixtures/credentials_sample.yml.enc")))
        end

        it "prints values for every environments" do
          regexp = [
            "development:",
            "aws.access_key_id:", "REMOVED: was 123",
            "aws.secret_access_key:", "REMOVED: was 345",
            "new_key:", 'CHANGED: "new_value" => "new_dev_value"',
            "added.key:", 'ADDED: "dev_val"',
            "test:",
            "aws.access_key_id:", "REMOVED: was 123",
            "aws.secret_access_key:", "REMOVED: was 345",
            "new_key:", 'CHANGED: "new_value" => "new_test_value"',
            "added.key:", 'ADDED: "test_val"'
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
        end
      end
    end
  end
end
