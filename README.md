# Sortviz

Sortviz is a sorting algorithm visualizer. But here's the rub, it's terminal
based. You guessed it! This sweet little tool will visualize sorting algorithms
for your viewing pleasures, it's written in Ruby and uses Curses for the terminal work.

It also has a rather over simplified plugin architecture, more like a ruby 
trick than anything. You can write your own sorting code and have it visualize
that for you. You just need to follow a general principle.

## Working with Sortviz

Some sorting algorithms operate on single lists, swapping and sifting through
it. Others operate on multiple lists, like merge sort. With any luck, you
might be able to get these kind of sorting algorithms working but until I officially test against them, you're on your own.

__Generally speaking, the sorting algorithm (your code) has to yield a partially sorted list, with a current index on *every iteration*__.

For examples, check the `algorithms` folder. 

Some implementations like the bubble sort one at `algorithms/bubblesort.rb` generate some visual artifacts. 
If you look at it, you'd notice that the index we're yielding is +1.

The reason for that is because otherwise, Sortviz will be selecting a column
that might in fact be the real current index, but the actual swapping is happening a column + 1. Which becomes confusing, so we +1 to select the
actual column that's moving around.

## Installation

This gem is not intended for your application's Gemfile, it's a
ruby program packaged as a Gem:

install it as:

    $ gem install sortviz

## Usage

```shell
$ sortviz -h      # Will display help
$ sortviz -l      # Will give you a list of available sorting algorithms
$ sortviz -s ALGO # Will start visualizing the sorting of 20 digits using that algorithm
```

__Notice: I haven't yet added the ability to load algorithms from a folder of your choosing, but its pretty much the same concept as of loading them from the `algorithms` folder__

## Development

*I'm using RVM to manage my Ruby and Gemset environments for the development of this Gem. So if you too are doing the same, careful cause I've checked in the following files `.ruby-gemset` and `.ruby-version`. If you don't know what I'm talking about, ignore this.*

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/l0gicpath/sortviz. (This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct) I Awe there, bundler is really sweet, isn't it?

Seriously now, PRs are welcome, bug reports too but don't make me do your
job for you. It's OSS, be reasonable.

## Why

Because I'm a terminal guy that's why. I like to think I'm not too
bad googling either and for the life of me I couldn't find anything similar
when a buddy of mine that teaches CS at a university was like, I need a terminal based sorting visualizer. I'm like PSH! Like there has to be some out there, lo-and-behold, they're all web and javascript based.

I'm also using this as a demo for an interview, hope it works out. They asked
for code I'm most proud of, pretty hard question to find an answer to, as it turns out.
It's not like I write code I'm not generally proud of but yeah, was a real
bummer looking over everything I worked in, so this is my solution.

Am I proud of it? Well yes, could be way better but I'm pressed on time.

## Future

When I started this, I wanted something that's easy to use to learn more
about sorting. So I might actually expand on that and allow a way to 
write sorting algorithms using pseudocode instead of Ruby.

Should be a fun little language design exercise.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
I wouldn't know why wouldn't you like MIT license but just in case you don't, 
don't ping me saying it sucks. Ping bundler, they make it absurdly easy not to
think about licensing when creating a new Gem.

