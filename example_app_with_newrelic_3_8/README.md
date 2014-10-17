Example App
================

A [Grape](http://github.com/intridea/grape) API mounted on Rack to demonstrate [newrelic-grape](https://github.com/xinminlabs/newrelic-grape).

* [ping](api/ping.rb): a hello world example that returns a JSON document

Run
___

```
$bundle install
$rackup
```

### Ping

Navigate to http://localhost:9292/api/ping with a browser or use `curl`.

```
$ curl http://localhost:9292/api/ping

{"ping":"pong"}
```

New Relic
---------

The application is setup with NewRelic w/ Developer Mode. Navigate to http://localhost:9292/newrelic after making some API calls.
