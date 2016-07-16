
require 'benchmark'

$: << File.expand_path(File.dirname(__FILE__)+"/..")

require "bundler/setup"
require "ffi/mmap"

Tempfile.create('ffi-mmap') do |f|

  size = 10*1048576
  f.write((0..size).collect { rand(255).chr }.join )

  m = FFI::Mmap.new(f.path, "r", FFI::Mmap::MAP_SHARED)

  n = 100000

  puts "Doing #{n} operations"
  puts

  Benchmark.bm do |x|
    f.seek(0, IO::SEEK_SET)
    while f.read(65536); end

    x.report("seek/read (64K reads):                    ") do
      n.times do
        f.seek(rand(size-100000), IO::SEEK_SET)
        f.read(65536)
      end
    end

    x.report("seek/read (4K reads):                     ") do
      n.times do
        f.seek(rand(size-100000), IO::SEEK_SET)
        f.read(4096)
      end
    end

    x.report("mmap (including mmap/unmap; 64K reads):   ") do
      m2 = FFI::Mmap.new(f.path, "r", FFI::Mmap::MAP_SHARED)
      first = rand(size-100000)
      m2[first..(first+65535)]
      m2.munmap
    end

    x.report("mmap (including mmap/unmap; 4K reads):    ") do
      m2 = FFI::Mmap.new(f.path, "r", FFI::Mmap::MAP_SHARED)
      first = rand(size-100000)
      m2[first..(first+4095)]
      m2.munmap
    end

    x.report("mmap (excluding mmap/unmap; 64K reads):   ") do
      first = rand(900000)
      m[first..(first+65536)]
    end

    x.report("mmap (excluding mmap/unmap; 4K reads):    ") do
      first = rand(size-100000)
      m[first..(first+4095)]
    end

    m.munmap

  end

end
