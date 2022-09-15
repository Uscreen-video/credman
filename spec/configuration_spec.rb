require "spec_helper"

RSpec.describe Credman::Configuration do
  let(:fresh_class) { Credman::Configuration.reset }
  let(:config) { fresh_class.instance }

  describe ".add_setting" do
    it "adds new setting" do
      expect { config.new_setting }.to raise_error(NoMethodError)

      fresh_class.add_setting(:new_setting, :default_value)

      expect(config.new_setting).to eq :default_value
      expect(config.settings_list).to include(:new_setting)
    end
  end

  describe "#settings_list" do
    subject { config.settings_list }

    it "include all available settings" do
      is_expected.to match_array %i[available_environments default_diff_branch]
    end
  end

  describe "#setting_exists?" do
    subject { config.setting_exists?(setting) }

    context "with existing setting" do
      let(:setting) { :available_environments }

      it { is_expected.to be true }
    end

    context "with unknown setting" do
      let(:setting) { :unknown_setting }

      it { is_expected.to be false }
    end
  end

  describe "#load_from_yml" do
    subject(:perform) { config.load_from_yml(config_path) }

    context "when config file is didn't find" do
      let(:config_path) { "unknown_file.yml" }

      it "do nothing" do
        expect(YAML).not_to receive(:load_file)
        is_expected.to be_nil
      end
    end

    context "when config file loaded" do
      let(:config_path) { "spec/fixtures/config_file.yml" }

      it "rewrite all possible settings" do
        perform

        expect(config.default_diff_branch).to eq "test"
        expect(config.available_environments).to match_array %w[test]
        expect { config.unknown_setting }.to raise_error(NoMethodError)
      end
    end
  end
end
