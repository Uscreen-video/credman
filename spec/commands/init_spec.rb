require "spec_helper"

RSpec.describe Credman::Init do
  describe "#perform" do
    subject(:perform) { described_class.new.perform(force_rewrite) }

    let(:force_rewrite) { false }
    let(:available_environments) { %w[development test production] }
    let(:config) do
      <<~CNF
        default_diff_branch: origin/main
        available_environments:
          - development
          - test
          - production
      CNF
    end

    context "when the config file doesn't exists" do
      before do
        allow_any_instance_of(described_class).to receive(:config_exists?).and_return(false)
        allow_any_instance_of(described_class).to receive(:available_environments).and_return(available_environments)
      end

      it "create and fill the config" do
        expect(File).to receive(:write).with("config/credman.yml", config).and_return(true)

        expect { perform }.to output("[CREATED] config/credman.yml\n").to_stdout
      end
    end

    context "when the config file exists" do
      before do
        allow_any_instance_of(described_class).to receive(:config_exists?).and_return(true)
        allow_any_instance_of(described_class).to receive(:available_environments).and_return(available_environments)
      end

      it "skip creating file" do
        expect(File).not_to receive(:write)

        msg = "[SKIPPED] config/credman.yml already exist. You can run with `--force-rewrite` option to rewrite it\n"
        expect { perform }.to output(msg).to_stderr
      end

      context "with --force-rewrite flag" do
        let(:force_rewrite) { true }

        it "create and fill the config" do
          expect(File).to receive(:write).with("config/credman.yml", config).and_return(true)

          expect { perform }.to output("[CREATED] config/credman.yml\n").to_stdout
        end
      end
    end
  end
end
