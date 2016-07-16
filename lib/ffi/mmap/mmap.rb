
module FFI
    class Mmap
        # FFI interface to the C library.
        module Internal
            extend FFI::Library
            ffi_lib FFI::Library::LIBC
        
            attach_function :mmap, [ :pointer, :ulong, :int, :int, :int, :uint ], :pointer
            attach_function :munmap, [:pointer, :ulong], :int
        end
        
        PROT_READ=1
        MAP_SHARED=1
        
        def initialize(filename, mode, flags)
            @f    = File.open(filename, mode)
            @size = @f.size
            @m    = FFI::AutoPointer.new(Internal.mmap(nil,@size,PROT_READ, flags,@f.fileno,0),
                self.method(:munmap))
            raise "Mmap failed" if @m.address == 0xffffffffffffffff
        end
        
        # Called automatically on gc thanks to FFI::AutoPointer wrapper around @m
        def munmap(_=nil)
            Internal.munmap(@m,@size)
            @m = nil
        end
        
        def[] ndx
            first = ndx.first
            last  = ndx.last
            last = @size-1 if last >= 0 && last >= @size
            @m.get_bytes(first, last - first+1)
        end
    end
end

