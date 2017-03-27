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

  def get_eng(input)
    tokenizer = Tokenizer.new(StringIO.new(input))
    eng = CompileEngine.new(tokenizer.types)
    eng.process!
    eng
  end

  describe "#compile_class" do
    it "compiles an empty class" do
      input = <<-EOF
        class Foo {}
      EOF

      # empty out
      eng = get_eng(input)
      expect(eng.class_name).to eq('Foo')
      expect(eng.to_s).to eq(expected(input))
    end
  end

  describe "#compile_class_var" do
    it "compiles an empty class" do
      input = <<-EOF
        class Foo {
          static int x, y;
          field int z;
        }
      EOF

      # empty out
      eng = get_eng(input)
      expect(eng.class_symbols.get('x').to_a).to eq(['x', 'int', 'STATIC', 0])
      expect(eng.class_symbols.get('y').to_a).to eq(['y', 'int', 'STATIC', 1])
      expect(eng.class_symbols.get('z').to_a).to eq(['z', 'int', 'FIELD', 0])
      expect(eng.to_s).to eq(expected(input))
    end
  end

  describe "#compile_subroutine" do
    it "writes a function name" do
      input = <<-EOF
        class Foo {
          function void main() {
            return;
          }
        }
      EOF

      eng = get_eng(input)
      expect(eng.class_name).to eq('Foo')
      expect(eng.function_name).to eq('main')
      expect(eng.to_s).to include('function Foo.main 0')
      expect(eng.to_s).to eq(expected(input))
    end

    #it "defines no arguments"
    #it "defines multiple arguments"
    #it "defines arg 0 if it is a method"
    #it "replaces local variables"
    #it "replaces class variables"
    describe "return" do
      it "handles an empty return" do
        input = <<-EOF
          class Foo {
            function void main() {
              return;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('push constant 0')
        expect(eng.to_s).to include('return')
        expect(eng.to_s).to eq(expected(input))
      end

      #it "handles returning a constant"
      #it "handles returning an expression"
    end
    #describe "#compile_var_dec" do
      #it "outputs the count of var decs"
    #end
    #describe "if/else statements"
    #describe "let statements"
    #describe "do statements"
    #describe "while statements"
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

    #describe "components" do
      #xit "handles let statements with function calls" do
        #expected = <<-EOF
        #EOF
        #input = <<-EOF
        #EOF

        #eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types)
        #eng.process!
        #expect(eng.to_s).to eq(strip(expected))
      #end
    #end

    #xit "has identical output for seven" do
      #jack_file = seven.sub('.vm', '.jack')
      #eng = CompileEngine.new(Tokenizer.new(File.open(jack_file)).types)
      #eng.process!
      #expect(eng.to_s).to eq(File.read(seven))
    #end
  end
end
