# Sortviz

[![Maintainability](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability)](https://codeclimate.com/github/l0gicpath/sortviz)

Sortviz is a small terminal program written in Ruby and uses the Curses library
It lets you visualize sorting algorithms, you can add more sorting algorithms
at will but for the time being it can only load the ones bundled with itself.

However, for pointers about writing plugins, check 
[lib/algorithms](lib/algorithms) and check the plugin system at
[lib/sortviz/algorithms.rb](lib/sortviz/algorithms.rb).

## Looks like this
![Screenshot][screenshot]

## Installation

This gem is not intended for your application's Gemfile, it's a
ruby program packaged as a Gem:

install it as:

    $ gem install sortviz

## Usage

```shell
$ sortviz -h
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/l0gicpath/sortviz. Please read [Contributor Covenant](http://contributor-covenant.org) and kindly attempt to adhere to it.

And don't make me do your job for you. It's OSS, be reasonable.

## Why

I blogged about this here:
[Software, a labor of love](http://hadyahmed.com/2016/06/software-a-labor-of-love/)

## Future

I want this to be a teaching tool, so I'll be expanding this to support writing sorting code using pseudocode instead of Ruby.
Should be a fun little language design exercise.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[screenshot]: screenshot.png "Mac OSX Terminal.app xterm-256color"
