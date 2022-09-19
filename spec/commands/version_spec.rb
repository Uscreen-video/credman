require "spec_helper"

RSpec.describe Credman do
  describe "run command" do
    context "with version argument" do
      subject { `bin/credman version` }

      it "outputs current version" do
        is_expected.to eq "#{Credman::VERSION}\n"
      end
    end

    context "with -v argument" do
      subject { `bin/credman -v` }

      it "outputs current version" do
        is_expected.to eq "#{Credman::VERSION}\n"
      end
    end

    context "with --version argument" do
      subject { `bin/credman --version` }

      it "outputs current version" do
        is_expected.to eq "#{Credman::VERSION}\n"
      end
    end
  end
end
