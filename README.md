# Croperty

Just for fun to use `annotation` to behave as `Object#property`, `Object#getter`, `Object#setter`

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     croperty:
       github: firejox/croperty
   ```

2. Run `shards install`

## Usage

```crystal
require "croperty"

@[Croperty::Property(x: Int32, init: 1)]
class Foo
  include Croperty::Generator(self)
end

foo = Foo.new
puts foo.x # => 1
```

## Contributing

1. Fork it (<https://github.com/firejox/croperty/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Firejox](https://github.com/firejox) - creator and maintainer
