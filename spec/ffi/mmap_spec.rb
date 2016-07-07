require 'spec_helper'

describe FFI::Mmap do
  let(:data) { rand(255).chr*4096 }

  let(:m) {
        File.open("/tmp/mmaptest","wb") {|f| f.write(data) }
        FFI::Mmap.new("/tmp/mmaptest","r", FFI::Mmap::MAP_SHARED)
  }

  it 'has a version number' do
    expect(FFI::Mmap::VERSION).not_to be nil
  end

  describe '#new' do
    it 'creates a new memory map' do
        expect(m).to_not be_nil
    end
  end
  
  describe "#[]" do
    it 'accepts a range and returns the file contents in that range' do
        expect(m[0..4095]).to eq(data)
    end
  end
  
end
