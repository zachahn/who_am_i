# WhoAmI

[![Build Status](https://travis-ci.org/zachahn/who_am_i.svg?branch=master)](https://travis-ci.org/zachahn/who_am_i)

> Who am I? &mdash; <cite>Hansel</cite>

> Who am I? &mdash; <cite>Katy Perry</cite>

> Who am I? &mdash; <cite>Neil deGrasse Tyson</cite>

> Who am I? &mdash; <cite>Zoolander</cite>

WhoAmI comments at the top of your model file with a list of the table's
columns.

Please remember to use version control before using WhoAmI. I've definitely
written a few bugs in my lifetime.


## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "who_am_i", require: false
end
```

And then execute:

    $ bundle

In your `Rakefile`:

```ruby
require "who_am_i/rake"

# ...
# after `Rails.application.load_tasks`
WhoAmI.load_rake_tasks
```


## Usage

Run `rake who_am_i` to update your model files.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## Contributing

Bug reports and pull requests are welcome on GitHub at
[https://github.com/zachahn/who_am_i](https://github.com/zachahn/who_am_i).


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
