require "./spec_helper"

describe CanUse do
  describe ".configure" do
    context "when file is not set on the configuration" do
      it "raises an error" do
        expect_raises CanUse::Error, "feature_one not found" do
          CanUse.feature?("feature_one")
        end
      end
    end
  end

  describe ".feature?" do
    CanUse.configure do |config|
      config.file = "spec/fixture/features.yml"
    end

    it "raises an error when a feature key does not exist" do
      expect_raises CanUse::Error, "does_not_exist not found" do
        CanUse.feature?("does_not_exist")
      end
    end

    context "accepts a block" do
      it "evaluates it when feature? returns true" do
        evaluated = false

        CanUse.feature?("feature_one") do
          evaluated = true
        end

        evaluated.should be_true
      end

      it "does not evaluate it when feature? returns false" do
        evaluated = false

        CanUse.feature?("feature_two") do
          evaluated = true
        end

        evaluated.should be_false
      end
    end

    context "with no environment defined" do
      it "uses the defaults value" do
        allowed = CanUse.feature?("feature_one")
        allowed.should be_true

        allowed = CanUse.feature?("feature_two")
        allowed.should be_false
      end
    end

    context "when development environment defined" do
      Spec.before_each do
        CanUse.configure do |config|
          config.environment = "development"
        end
      end

      it "uses the defaults value" do
        allowed = CanUse.feature?("feature_one")
        allowed.should be_true
      end

      it "uses development environment if the key exists" do
        allowed = CanUse.feature?("feature_two")
        allowed.should be_true
      end
    end
  end
end
