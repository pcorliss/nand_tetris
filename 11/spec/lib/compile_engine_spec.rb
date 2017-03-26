require './lib/compile_engine.rb'
require './lib/tokenizer.rb'
require 'pry'
#require 'tempfile'
require 'digest'

describe CompileEngine do
  def expected(input)
    md5 = Digest::MD5.hexdigest input
    jack_dir = "spec/fixtures/cache/#{md5}"
    jack_file = "#{jack_dir}/Foo.jack"
    vm_file = "#{jack_dir}/Foo.vm"
    Dir.mkdir(jack_dir) unless Dir.exist?(jack_dir)
    File.write(jack_file, input) unless File.exist?(jack_file)
    `JackCompiler.sh #{jack_file}` unless File.exist?(vm_file)
    # could throw an error here if it fails to compile
    File.read(vm_file)
  end

  let(:input) { '' }
  let(:output) do
    eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types)
    eng.process!
    eng.to_s
  end

  describe "#compile_class" do
    it "compiles an empty class" do
      input = <<-EOF
        class Foo { }
      EOF

      # empty out
      expect(output).to eq(expected(input))
    end

    it "prefixes function definitions" do
      input = <<-EOF
        class Foo {
          function void main() {
            return;
          }
        }
      EOF

      expect(output).to include('function Foo.main 0')
      expect(output).to eq(expected(input))
    end
  end

  describe "#compile_class_var" do
  end

  describe "#compile_subroutine" do
  end

  describe "#compile_var_dec" do
  end

  describe "compile statements" do
  end

  it "handles if/else statements" do
  end

  describe "samples" do
    def strip(str)
      # remove trailing new line and left align content
    end

    let(:seven) { 'Seven/Main.vm' }
    let(:convert) { 'ConvertToBin/Main.vm' }

    let(:square_main) { 'Square/Main.vm' }
    let(:square_square) { 'Square/Square.vm' }
    let(:square_game) { 'Square/SquareGame.vm' }

    let(:avg) { 'Average/Main.vm' }

    let(:pong_ball) { 'Pong/Ball.vm' }
    let(:pong_bat) { 'Pong/Bat.vm' }
    let(:pong_main) { 'Pong/Main.vm' }
    let(:pong_game) { 'Pong/PongGame.vm' }

    let(:arrays) { 'ComplexArrays/Main.vm' }

    describe "components" do
      xit "handles let statements with function calls" do
        expected = <<-EOF
        EOF
        input = <<-EOF
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types)
        eng.process!
        expect(eng.to_s).to eq(strip(expected))
      end
    end

    xit "has identical output for seven" do
      jack_file = seven.sub('.vm', '.jack')
      eng = CompileEngine.new(Tokenizer.new(File.open(jack_file)).types)
      eng.process!
      expect(eng.to_s).to eq(File.read(seven))
    end
  end
end
