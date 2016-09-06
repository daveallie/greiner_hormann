# Greiner-Hormann polygon clipping in Ruby

Uses the [Greiner-Hormann clipping algorithm](https://en.wikipedia.org/wiki/Greiner%E2%80%93Hormann_clipping_algorithm).

## Installation

Add this line to your application's Gemfile:

    gem 'greiner_hormann'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install greiner_hormann

## Usage

```ruby
require 'greiner_hormann'
poly1 = [[0, 0], [0, 1], [1, 1], [1, 0]]
poly2 = [[0.5, 0.5], [0.5, 1.5], [1.5, 1.5], [1.5, 0.5]]

GreinerHormann.union(poly1, poly2)
# => [[[0.5, 1.0], [0, 1], [0, 0], [1, 0], [1.0, 0.5], [1.5, 0.5], [1.5, 1.5], [0.5, 1.5]]]

GreinerHormann.intersection(poly1, poly2)
# => [[[0.5, 1.0], [1, 1], [1.0, 0.5], [0.5, 0.5]]]

GreinerHormann.difference(poly1, poly2)
# => [[[0.5, 1.0], [0, 1], [0, 0], [1, 0], [1.0, 0.5], [0.5, 0.5]]]
```

## Contributing

1. Fork it ( http://github.com/daveallie/greiner_hormann/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
