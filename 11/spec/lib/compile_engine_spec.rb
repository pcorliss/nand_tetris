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

    it "defines no arguments" do
      input = <<-EOF
        class Foo {
          function void main() {
            return;
          }
        }
      EOF

      eng = get_eng(input)
      expect(eng.sub_symbols.count).to eq(0)
      expect(eng.to_s).to eq(expected(input))
    end

    it "defines multiple arguments" do
      input = <<-EOF
        class Foo {
          function void main(int x, int y) {
            return;
          }
        }
      EOF

      eng = get_eng(input)
      expect(eng.sub_symbols.count).to eq(2)
      expect(eng.sub_symbols.count('arg')).to eq(2)
      expect(eng.to_s).to eq(expected(input))
    end

    it "defines arg 0 if it is a method" do
      input = <<-EOF
        class Foo {
          method void main(int x, int y) {
            return;
          }
        }
      EOF

      eng = get_eng(input)
      expect(eng.sub_symbols.count).to eq(3)
      expect(eng.sub_symbols.count('arg')).to eq(3)
      expect(eng.sub_symbols.get('this').to_a).to eq(['this', 'Foo', 'ARG', 0])
      expect(eng.to_s).to include('push argument 0', 'pop pointer 0')
      expect(eng.to_s).to eq(expected(input))
    end

    it "handles multiple functions" do
      input = <<-EOF
        class Foo {
          function void main() {
            return;
          }
          function void foo(int x, int y) {
            return;
          }
        }
      EOF

      eng = get_eng(input)
      expect(eng.to_s).to eq(expected(input))
    end

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
    end

    describe "expressions" do
      it "handles constant expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('push constant 1')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles basic addition expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 + 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('push constant 1')
        expect(eng.to_s).to include('push constant 2')
        expect(eng.to_s).to include('add')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles lookups of args" do
        input = <<-EOF
          class Foo {
            function int main(int x) {
              return x;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('push argument 0')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles lookups of fields/this" do
        input = <<-EOF
          class Foo {
            field int x;

            method int main() {
              return x;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('push this 0')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles lookups of statics" do
        input = <<-EOF
          class Foo {
            static int x;

            function int main() {
              return x;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('push static 0')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles lookups of vars" do
        input = <<-EOF
          class Foo {
            function int main() {
              var int x;
              return x;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('push local 0')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles boolean true" do
        input = <<-EOF
          class Foo {
            function boolean main() {
              return true;
            }
          }
        EOF

        eng = get_eng(input)
        #expect(eng.to_s).to include('push local 0')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles boolean false" do
        input = <<-EOF
          class Foo {
            function boolean main() {
              return false;
            }
          }
        EOF

        eng = get_eng(input)
        #expect(eng.to_s).to include('push local 0')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles this" do
        input = <<-EOF
          class Foo {
            method Foo main() {
              return this;
            }
          }
        EOF

        eng = get_eng(input)
        #expect(eng.to_s).to include('push local 0')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles null" do
        input = <<-EOF
          class Foo {
            function boolean main() {
              return null;
            }
          }
        EOF

        eng = get_eng(input)
        #expect(eng.to_s).to include('push local 0')
        expect(eng.to_s).to eq(expected(input))
      end
      it "handles basic subtraction expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 - 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('sub')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles basic multiplication expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 * 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('call Math.multiply 2')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles basic division expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 / 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('call Math.divide 2')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles negative expression" do
        input = <<-EOF
          class Foo {
            function boolean main() {
              return - 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('neg')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles negation expression" do
        input = <<-EOF
          class Foo {
            function boolean main() {
              return ~ 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('not')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles and expression" do
        input = <<-EOF
          class Foo {
            function boolean main() {
              return 1 & 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('and')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles or expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 | 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('or')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles less than expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 < 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('lt')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles greater than expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 > 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('gt')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles equality expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 1 = 2;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('eq')
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles simple nested constant" do
        input = <<-EOF
          class Foo {
            function int main() {
              return (((((1)))));
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles simple nested expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return ((((1)+(2))));
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to eq(expected(input))
      end

      it "handles more complex nested expression" do
        input = <<-EOF
          class Foo {
            function int main() {
              return 0<((1+2)-(3*(4/5)));
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to eq(expected(input))
      end

      context "function calls" do
        it "handles function call expression" do
          input = <<-EOF
            class Foo {
              method int main() {
                return Bar.foo();
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end

        it "handles method function call expression" do
          input = <<-EOF
            class Foo {
              method int main() {
                return foo();
              }

              method int foo() {
                return 0;
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end

        it "handles function call expression with multiple arguments" do
          input = <<-EOF
            class Foo {
              method int main() {
                return foo(0, 1) + Foo.bar(2);
              }

              method int foo(int i, int j) {
                return i + j;
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end

        it "handles function call expression with complicated expressions" do
          input = <<-EOF
            class Foo {
              method int main() {
                return foo(0, 1 + 9) + (4 + Bar.foo(1, 2 + 3, (4) * (5 / 6)));
              }

              method int foo(int i, int j) {
                return i + j;
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end
      end

      context "array access" do
        it "handles array access expression" do
          input = <<-EOF
            class Foo {
              function int main() {
                var Array a;
                return a[6];
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end

        # a[i] + b[j]
        it "handles nested array access expression" do
          input = <<-EOF
            class Foo {
              function int main() {
                var Array a, b, c, d;
                return a[b[c[d[7]]]];
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end

        it "handles expressions inside array lookups" do
          input = <<-EOF
            class Foo {
              function int main() {
                var Array a;
                return a[(1 - 4) + (6 * 7)];
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end

        it "handles expressions involving arrays" do
          input = <<-EOF
            class Foo {
              function int main() {
                var Array a, b, c, d;
                return a[b[7]] + c[d[4]];
              }
            }
          EOF

          eng = get_eng(input)
          expect(eng.to_s).to eq(expected(input))
        end
      end
    end

    describe "#compile_var_dec" do
      it "outputs the count of var decs" do
        input = <<-EOF
          class Foo {
            function void main() {
              var int x, y;
              var String z;
              return;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.to_s).to include('function Foo.main 3')
        expect(eng.to_s).to eq(expected(input))
      end

      it "defines local vars" do
        input = <<-EOF
          class Foo {
            function void main() {
              var int x, y;
              var String z;
              return;
            }
          }
        EOF

        eng = get_eng(input)
        expect(eng.sub_symbols.get('x').to_a).to eq(['x', 'int', 'VAR', 0])
        expect(eng.sub_symbols.get('y').to_a).to eq(['y', 'int', 'VAR', 1])
        expect(eng.sub_symbols.get('z').to_a).to eq(['z', 'String', 'VAR', 2])
        expect(eng.to_s).to eq(expected(input))
      end
    end

    describe "let statements" do
      #it "allows setting an array element"
      #it "allows setting a nested array element"
    end
    describe "do statements"
    describe "if/else statements"
    describe "while statements"
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
