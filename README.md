# NewRelic::Grape

NewRelic instrument for [grape][0], this is inspired from this [blog post][1].

## Installation

Add this line to your application's Gemfile:

    gem 'newrelic-grape'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newrelic-grape

## Usage

That's it.

## Disabling Instrumentation

Set `disable_grape` in `newrelic.yml` or `ENV['DISABLE_NEW_RELIC_GRAPE']` to disable instrumentation.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Update `CHANGELOG.md` describing your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

[0]: https://github.com/intridea/grape
[1]: http://artsy.github.com/blog/2012/11/29/measuring-performance-in-grape-apis-with-new-relic/
