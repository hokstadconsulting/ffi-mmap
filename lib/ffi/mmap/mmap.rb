
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
            @f = ::IO.sysopen(filename) # FIXME: mode
            @len = 4096 # FIXME
            @m = FFI::AutoPointer.new(Internal.mmap(nil,@len,PROT_READ,MAP_SHARED,@f,0),
                self.method(:munmap))
            raise "Mmap failed" if @m.address == 0xffffffffffffffff
        end
        
        # Called automatically on gc thanks to FFI::AutoPointer wrapper around @m
        def munmap(_)
            Internal.munmap(@m,@len)
            @m = nil
        end
        
        def[] ndx
            @m.get_bytes(ndx.first, ndx.last - ndx.first+1)
        end
    end
end

