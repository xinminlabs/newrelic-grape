# NewRelic::Grape

NewRelic instrumentation for the [Grape API DSL][0], inspired by [this blog post][1].

## Installation

Add this line to your application's Gemfile:

    gem 'newrelic-grape'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newrelic-grape
    
If you're using Rails, make sure that you've told rack to start the agent for Grape:

    # config.ru
    require ::File.expand_path('../config/environment',  __FILE__)

    # You need to manually start the agent
    NewRelic::Agent.manual_start

    run YourApplication::Application
    

## Usage

Ensure that you have working NewRelic instrumentation. Add the `newrelic-grape` gem. That's it.

## Disabling Instrumentation

Set `disable_grape` in `newrelic.yml` or `ENV['DISABLE_NEW_RELIC_GRAPE']` to disable instrumentation.

## Testing

This gem naturally works in NewRelic developer mode. For more information see the [NewRelic Developer Documentation][2].

To ensure instrumentation in tests, check that `perform_action_with_newrelic_trace` is invoked on an instance of `NewRelic::Agent::Instrumentation::Grape` when calling your API.

### RSpec

``` ruby
describe NewRelic::Agent::Instrumentation::Grape do
  it "traces" do
    NewRelic::Agent::Instrumentation::Grape
      .any_instance
      .should_receive(:perform_action_with_newrelic_trace)
      .and_yield
    get "/ping"
    response.status.should == 200
  end
end
```

## Demos

* [Grape on Rack w/ NewRelic Instrumentation Enabled][3]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Update `CHANGELOG.md` describing your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

[0]: https://github.com/intridea/grape
[1]: http://artsy.github.com/blog/2012/11/29/measuring-performance-in-grape-apis-with-new-relic
[2]: https://newrelic.com/docs/ruby/developer-mode
[3]: https://github.com/dblock/grape-on-rack
