# Sortviz

Sortviz is a small terminal program written in Ruby and uses the Curses library
It lets you visualize sorting algorithms, you can add more sorting algorithms
at will but for the time being it can only load the ones bundled with itself.

For pointers on the over simplified (Quite bad too) plugin system, check 
[lib/sortviz/plugins.rb](lib/sortviz/plugins.rb) and check the plugins at
[lib/algorithms](lib/algorithms).

## Looks like this
![Screenshot][screenshot]

## Working with Sortviz

Some sorting algorithms operate on single lists, swapping and sifting through
them. Others operate on multiple lists, like merge sort. With any luck, you
might be able to get these kind of sorting algorithms working but until I officially test against them, you're on your own.

__Generally speaking, the sorting algorithm (your code) has to yield a partially sorted list, with a current index on *every iteration*__.

For examples, check the [lib/algorithms](lib/algorithms) directory. 

Some implementations like the bubble sort one at [lib/algorithms/bubblesort.rb](lib/algorithms/bubblesort.rb) generate some visual artifacts. 
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
## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/l0gicpath/sortviz. Please read [Contributor Covenant](http://contributor-covenant.org) and kindly attempt to adhere to it.

And don't make me do your job for you. It's OSS, be reasonable.

## Why

Because I'm a terminal guy that's why. I like to think I'm not too
bad googling either and for the life of me I couldn't find anything similar
when a buddy of mine that teaches CS at a university was like, I need a terminal based sorting visualizer. I'm like PSH! Like there has to be some out there, lo-and-behold, they're all web and javascript based.

I was asked for code I'm most proud of, a pretty hard question to find an answer to, as it turns out. It's not like I write code I'm not generally proud of but yeah, was a real bummer looking over everything I worked in, so this is my solution.

Am I proud of it? Well yes, I'm improving it by time.

*I realized the notion of being proud of something is more of a process, after you've invested time and effort into something and grew it, you can't help but feel proud of it.*

## Future

I want this to be a teaching tool, so I'll be expanding this to support writing sorting code using pseudocode instead of Ruby.
Should be a fun little language design exercise.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[screenshot]: screenshot.png "Mac OSX Terminal.app xterm-256color"
