# can_use

🤔Can I use this feature? Hmm, let me see.

> CanUse is a minimalist feature toggle/flag for crystal, based on yaml file.

[![GitHub release](https://img.shields.io/github/release/rodrigopinto/can_use.svg)](https://github.com/rodrigopinto/can_use/releases) [![Build Status](https://travis-ci.org/rodrigopinto/can_use.svg?branch=master)](https://travis-ci.org/rodrigopinto/can_use)

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  can_use:
    github: rodrigopinto/can_use
```
2. Run `shards install`

## Usage

1. Require the library on your code base.

```crystal
require "can_use"
```

2. Create a file with the features toggle definitions.
We suggest to name it as `featutes.yaml`, but it is up to you.

	**Note:** The `defaults` block is mandatory, as it will be used as fallback when values are not defined on the environment set on `configuration`. Example:

```yaml
defaults:
  new_payment_flow: false
  rating_service: false

development:
  new_payment_flow: true
  rating_service: false

your_environment:
  new_payment_flow: true
```

3. Configure the environment and the path to the yaml.

```crystal
CanUse.configure do |config|
  config.file = "path/to/features.yaml"
  config.environment = "your_environment"
end
```

4. Verify if a feature is toggled on/off

```crystal
if CanUse.feature?("new_payment_flow")
  # do_something
end
```

5. Enabling or Disabling a feature is simple as

> Enabling

```crystal
CanUse.feature?("feature_a") # => false

CanUse.enable("feature_a") # => true

CanUse.feature?("feature_a") # => true
```

> Disabling

```crystal
CanUse.feature?("feature_b") # => true

CanUse.disable("feature_b") # => false

CanUse.feature?("feature_b") # => false
```

## Development

1. Install the dependencies.

```bash
$ shards install
```

2. Implement and test your changes.

```bash
$ crystal spec
```

3. Run fomart tool to verify code style.

```bash
$ crystal tool format
```

## TODO

- [ ] Allows ENVIRONMENT variables to set/override a value for a key.

## Contributing

1. Fork it (<https://github.com/rodrigopinto/can_use/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Rodrigo Pinto](https://github.com/rodrigopinto) - creator and maintainer

## Credits

This shard was initially inspired by [can_do](https://github.com/blacklane/can_do).
