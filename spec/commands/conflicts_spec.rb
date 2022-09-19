require "spec_helper"
require "fileutils"

RSpec.describe Credman::Conflicts do
  describe "#perform" do
    subject(:perform) { described_class.new(envs).perform }

    let(:envs) { %w[rspec] }

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

      before do
        allow_any_instance_of(Credman::Configuration).to receive(:available_environments).and_return(envs)
        stub_const("ENV", {"RAILS_MASTER_KEY" => "6c572cf4c3606c058ba95c8a9df292ce"})
        FileUtils.cp(cred_file_path, "config/credentials/rspec.yml.enc")
      end

      after { FileUtils.rm "config/credentials/rspec.yml.enc" }

      context "when no conflicts found" do
        let(:cred_file_path) { "spec/fixtures/credentials_sample.yml.enc" }

        it "prints no conflict found message" do
          regexp = ["rspec:", "No conflicts found"].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
          expect(instance.configs).to eq "rspec" => {aws: {access_key_id: 123, secret_access_key: 345}, new_key: "new_value"}
        end
      end

      context "with auto-solvable conflict" do
        let(:cred_file_path) { "spec/fixtures/git_conflict_solvable.yml.enc" }

        it "resolves conflict" do
          regexp = [
            "rspec:",
            "ADDED", "OUR", "new key", "another_key", "another_value",
            "ADDED", "THEIR", "new key", "new_key", "new_value",
            "Merged config for rspec has been saved"
          ].join(".+")

          expect { perform }.to output(/#{regexp}/m).to_stdout
          expect(instance.configs).to eq "rspec" => {another_key: "another_value", aws: {access_key_id: 123, secret_access_key: 345}, new_key: "new_value"}
        end
      end

      context "with non auto-solvable conflict" do
        let(:cred_file_path) { "spec/fixtures/git_conflict_unsolvable.yml.enc" }
        before { allow($stdin).to receive(:gets).and_return(user_input) }

        context "when user chose their" do
          let(:user_input) { "their\n" }

          it "resolves conflict with user input" do
            regexp = [
              "rspec:",
              "The key", "another_key", "changed in both branches, their:", "another_value", "our:", "conflicting_value",
              "Which one should we use?", "Please type", "their", "or", "our", "to apply particular change or enter to abort",
              "another_key", "set as", "another_value",
              "Merged config for rspec has been saved"
            ].join(".+")

            expect { perform }.to output(/#{regexp}/m).to_stdout
            expect(instance.configs["rspec"]).to include another_key: "another_value"
          end
        end

        context "when user chose our" do
          let(:user_input) { "our\n" }

          it "resolves conflict with user input" do
            regexp = [
              "rspec:",
              "The key", "another_key", "changed in both branches, their:", "another_value", "our:", "conflicting_value",
              "Which one should we use?", "Please type", "their", "or", "our", "to apply particular change or enter to abort",
              "another_key", "set as", "conflicting_value",
              "Merged config for rspec has been saved"
            ].join(".+")

            expect { perform }.to output(/#{regexp}/m).to_stdout
            expect(instance.configs["rspec"]).to include another_key: "conflicting_value"
          end
        end

        context "when user hit enter" do
          let(:user_input) { "\n" }

          it "aborts merging" do
            regexp = [
              "rspec:",
              "The key", "another_key", "changed in both branches, their:", "another_value", "our:", "conflicting_value",
              "Which one should we use?", "Please type", "their", "or", "our", "to apply particular change or enter to abort"
            ].join(".+")

            expect { perform }.to raise_error(SystemExit)
              .and output(/#{regexp}/m).to_stdout
              .and output(/Merge aborted. Config did not save./).to_stderr
          end
        end
      end
    end
  end
end
