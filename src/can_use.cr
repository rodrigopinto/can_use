require "yaml"

# CanUse is a minimalist feature toggle for Crystal.
module CanUse
  VERSION = "0.1.0"

  @@features = Hash(YAML::Any, YAML::Any).new
  @@config = Config.new

  # Sets the configuration for `CanUse`
  #
  # ### Example
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
  # ### Example
  #
  # ```
  # if CanUse.feature?("feature_one")
  #   # do_something
  # end
  # ```
  def self.feature?(name : String)
    features.fetch(name, defaults[name]).raw
  rescue KeyError
    raise Error.new("#{name} not found")
  end

  # Evaluates the block if the feature returns `true`..
  #
  # ### Example
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
