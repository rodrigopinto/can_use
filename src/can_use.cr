require "yaml"

# CanUse is a minimalist feature toggle for Crystal.
module CanUse
  VERSION = "0.2.0"

  @@features = Hash(YAML::Any, YAML::Any).new
  @@config = Config.new

  # Sets the configuration for `CanUse`
  #
  # ```
  # CanUse.configure do |config|
  #   config.environment = "development"
  #   config.file = "config/features.yml"
  # end
  # ```
  def self.configure
    yield @@config
    @@features = YAML.parse(File.read(@@config.file)).as_h
  end

  # Returns `true` or `false` based on the feature configuration.
  # Otherwise, reads from the default value.
  #
  # ```
  # if CanUse.feature?("feature_one")
  #   # do_something
  # end
  # ```
  def self.feature?(name : YAML::Any::Type)
    features.fetch(name, defaults[name]).as_bool
  rescue KeyError
    raise Error.new("#{name} not found")
  end

  # Evaluates the block if the feature returns `true`..
  #
  # ```
  # CanUse.feature?("feature_one") do
  #   puts "Yeah, I cam use!"
  # end
  # ```
  def self.feature?(name : String, &block)
    return unless feature?(name)

    yield
  end

  # Enables the feature and returns `true`.
  #
  # ```
  # CanUse.enable("feature_three") # => true
  # ```
  def self.enable(name : String)
    set_feature(name, true)
  end

  # Disables the feature and returns `false`.
  #
  # ```
  # CanUse.disable("feature_two") # => false
  # ```
  def self.disable(name : String)
    set_feature(name, false)
  end

  private def self.set_feature(name : String, value : Bool)
    key = YAML::Any.new(name)
    features[key] = YAML::Any.new(value)
  end

  private def self.features : Hash(YAML::Any, YAML::Any)
    @@features[@@config.environment].as_h
  end

  private def self.defaults : Hash(YAML::Any, YAML::Any)
    @@features[Config::DEFAULTS].as_h
  end

  class Error < Exception; end

  private class Config
    DEFAULTS = "defaults"

    property file : String = ""
    property environment = DEFAULTS
  end
end
