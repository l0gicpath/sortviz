# Sortviz

Sortviz is a small terminal program written in Ruby and uses the Curses library
It lets you visualize sorting algorithms, you can add more sorting algorithms
at will but for the time being it can only load the ones bundled with itself.

For pointers on the over simplified (Quite bad too) plugin system, check 
[lib/sortviz/plugins.rb](lib/sortviz/plugins.rb) and check the plugins at
[lib/algorithms](lib/algorithms).

## Looks like this
![Screenshot][screenshot]

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

## Sortviz Internals

### Initial thoughts
Initially, this started out with a simple concept. It was to have a piece of code doing the sorting, yielding a partially sorted list on every iteration.

It was to be yielded to a block provided by Sortviz for rendering each variation of the partially sorted list, which gave the illusion of sifting 
through each iteration, swapping and shifting list elements attempting to sort
them. I also controlled the speed of this visual swapping and shifting by
sleeping intervals of time.

### Introduction of a plugin system
It was also not intended to include every sorting algorithm and their implementations. The whole idea was to have sorting algorithms as pluggable nuggets of code. I solved this problem by a quick hack using `module_function`
and build a register of defined algorithms through a module method called `define_algorithms`. It worked well, but I didn't like it. Simply put, it 
exposed people's sorting code as part of Sortviz module namespace which polluted it.
The whole idea of building a plugin system is keeping the core clean and lean.

#### Plugin DSL
This later changed when I introduced the plugin DSL. Which made it really easy to add new sorting algorithms by using a simple DSL to define the algorithm's
meta data (author, url, name) and the actual sorting code, stored as a `Proc`.

It failed the smoke test, the original imagined implementation looked like this

```ruby
Sortviz::Algorithms.define 'Starwars Sort' do
  author 'Luke Skywalker'
  url 'http://www.starwars.com'
  name :'starwars-sort'

  sort do |unsorted_list|
    unsorted_list.each_index do |i|
      -sorting-code-
      yield unsorted_list, i
    end
  end
end
```
That of course didn't turn out as expected, a keen rubyist would slowly have it sinking in their soul as it sunk in after I wrote that and told myself, no no... I'm sure there's a way. Yes. Yield will throw a no block given, localjump error. Disheartening but true, no matter what you throw at that Proc it wont receive a block of code and will crack when it hits yield.
Procs are closures, they take a referenced copy of what it sees in its current lexical scope and context. 
The yield inside that Proc would be attempting to apply to the block that's given to the wrapping method context it was created in and my attempt to wrap it up in a method to circumvent that has failed. 

Unless I missed something, feel free to try, the only way to approach this is
by explicit blocks. Which resulted in this not-so-pretty implementation

```ruby
Sortviz::Algorithms.define 'Starwars Sort' do
  author 'Luke Skywalker'
  url 'http://www.starwars.com'
  name :'starwars-sort'

  sort do |unsorted_list, &renderblock|
    unsorted_list.each_index do |i|
      -sorting-code-
      renderblock.call(unsorted_list, i)
    end
  end
end
```
Defeated the whole purpose of a clean DSL. Still worked, but I'm unhappy.

#### Observable
The most recent idea in my quest for an elegant solution is the one I'm most
likely to settle on for a number of features that I probably wont be able to
implement reasonably well unless done in such a way:

- User needs to be able to step into the sorting, step back an iteration or fast forward multiple iterations.
- User also needs to be able to pause the sorting, slow it down and speed it up.
- User needs to tap into the sorting data and change them arbitrarily during the sorting and witness the effect of that.
- User needs to be able to write sorting code in Sortviz pseudocode, a small external DSL that resembles pseudocode. Which effectively makes Sortviz perfect for students

So what's this idea? I asked myself a question, why does the sorting algorithm
need to know about rendering during sorting (either by yielding or calling a block, or even calling a method). It doesn't as it turns out, in fact
what should be happening is for the sorting algorithm to sort as fast as it should, finish sorting and return the sorted data.

Wait, but how will we draw the visualization if the sorting algorithm simply
returns the already sorted data? It doesn't just return that, it also returns
the history of changes that took place on the unsorted list, in other words
we're implementing a watcher/observer pattern on the List data structure.

So the sorting algorithm wont do much but to sort, while we're recording and
monitoring changes happening with the List being sorted. Later, the visualization will have all the information it needs to implement the above features since it will have every change that happened turning the list from unsorted to sorted.

This also aligns with the idea of executable pseudocode code since I don't want to have to fiddle with context and execution flow switching between the host language (ruby) and the guest language (Sortviz pseudocode). I want Sortviz pseudocode to just run, do its thing and hand control back to Sortviz for visualization.

**I'm in the process of making this happen, watch _proper-plugins branch_**


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
