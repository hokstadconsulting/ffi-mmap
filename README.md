
# FFI::Mmap

**WARNING**: This is **VERY** incomplete as of writing this. It basically
only supports read-only shared mappings.

The 'Mmap' gem is showing its age and won't compile with all Ruby versions,
so this is a minimal FFI based implementation.


## Why you'd want to consider Mmap for random access to large files

There's a basic benchmark included. Try "make bench". Here are results
from my laptop:

```
$ make bench
docker run -t -i -v /home/vidarh/src/repos/purecdb/ffi-mmap:/app ffi-mmap ruby tests/bench.rb
Doing 100000 operations

       user     system      total        real
       seek/read (64K reads):                      0.650000   1.480000   2.130000 (  2.136277)
       seek/read (4K reads):                       0.200000   0.180000   0.380000 (  0.379838)
       mmap (including mmap/unmap; 64K reads):     0.000000   0.000000   0.000000 (  0.000164)
       mmap (including mmap/unmap; 4K reads):      0.000000   0.000000   0.000000 (  0.000070)
       mmap (excluding mmap/unmap; 64K reads):     0.000000   0.000000   0.000000 (  0.000045)
       mmap (excluding mmap/unmap; 4K reads):      0.000000   0.000000   0.000000 (  0.000014)
```

Caveats: Benchmarks are lies, and more lies; In this case the file used is 10MB, which is 
small enough that the more operations the more of the file will be cached in RAM. This 
favours the mmap solution. The more the file exceeds RAM size, the less favourable things
will be for mmap. But I don't feel like writing a multi-GB file to test with - feel free to
submit data. And make sure to benchmark your *actual* workload. Order of operations and actually
touching more of the mmap'd data might make a difference too, though reordering the tests
above have very little impact on the outcome.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ffi-mmap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ffi-mmap

## Usage

See rspec tests for now.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/hokstadconsulting/ffi-mmap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
