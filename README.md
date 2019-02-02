# WhoAmI

Note: Development of WhoAmI has moved to
[ahnnotate](https://github.com/zachahn/ahnnotate). Check it out!

[![Build Status](https://travis-ci.org/zachahn/who_am_i.svg?branch=master)](https://travis-ci.org/zachahn/who_am_i)

> Who am I? &mdash; <cite>Hansel</cite>

> Who am I? &mdash; <cite>Katy Perry</cite>

> Who am I? &mdash; <cite>Neil deGrasse Tyson</cite>

> Who am I? &mdash; <cite>Zoolander</cite>

WhoAmI comments at the top of your model file with a list of the table's
columns. This project is heavily inspired by the
[annotate](https://github.com/ctran/annotate_models) gem.

Please take the precaution of using version control when using WhoAmI, since the
primary function of this project is to overwrite your development files.


## Pros and cons

Annotate and WhoAmI have a similar feature-set, but their strengths are quite
different.

**Annotate** is much more fully featured and can annotate models, routes,
controllers, specs, factories, and much more. It's quite a bit slower (in my
benchmarks), and it seems like it only takes the filename into account when
determining how files should be annotated.

**WhoAmI** can only annotate models, but it is faster and more accurate. It
performs static analysis to see which files are models, and which models
correlate to which tables.


## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "who_am_i"
end
```

And then execute:

    $ bundle


## Usage

Run `rake who_am_i` to update your model files.

By default, `who_am_i` automatically runs after migrating your database.


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
[MIT License](LICENSE.txt).
