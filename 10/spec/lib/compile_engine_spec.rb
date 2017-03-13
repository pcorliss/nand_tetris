require './lib/compile_engine.rb'
require 'pry'

describe CompileEngine do
  let(:doc) { REXML::Document.new }
  let(:input_fh) { StringIO.new(input) }
  let(:tokens) { Tokenizer.new(input_fh).types }
  let(:eng) {CompileEngine.new(tokens, doc) }

  describe "#compile_class" do
    let(:input) {'class Foo {}'}

    it "updates the doc" do
      eng.process!
      expect(doc.root.name).to eq('class')
      expect(doc.root.children.map(&:name)).to eq(["keyword", "identifier", "symbol", "symbol"])
      expect(doc.root.children.map(&:text)).to eq(["class", "Foo", "{", "}"])
    end
  end

  describe "#compile_class_var" do
    let(:input) {<<-EOF
      class Foo {
        field Square square;
        static int foo, bar;
      }
      EOF
    }

    it "updates the doc" do
      #puts tokens.inspect
      eng.process!
      #binding.pry
      class_var_decs = doc.root.children.select {|e| e.name == 'classVarDec'}
      #puts class_var_decs.map(&:to_s).inspect
      expect(doc.root.name).to eq('class')
      expect(class_var_decs.count).to eq(2)
    end
  end

  describe "#compile_subroutine" do
    let(:input) {<<-EOF
      class Foo {
        constructor Foo new() {}
        method void move(int a) {}
        function int bar(int b, int c) {}
      }
      EOF
    }

    it "updates the doc" do
      #puts tokens.inspect
      eng.process!
      #puts doc.to_s.gsub(/></,">\n<")
      subs = doc.root.children.select {|e| e.name == 'subroutineDec'}
      #puts subs.map(&:to_s).inspect
      returns = subs.map { |s| s.children.select {|e| e.name == 'identifier' }.first.text }.flatten
      ids = subs.map { |s| s.children.select {|e| e.name == 'identifier' }.last.text }.flatten
      #puts ids.map(&:to_s).inspect
      param_lists = subs.map { |s| s.children.find { |e| e.name == 'parameterList' } }
      param_idents = param_lists.map { |p| p.children.select { |e| e.name == 'identifier' } }
      #puts "ParamIdents: #{param_idents.map(&:to_s).inspect}"
      #binding.pry

      sub_body = subs.map { |s| s.children.find { |e| e.name == 'subroutineBody' } }.compact

      expect(doc.root.name).to eq('class')
      expect(subs.count).to eq(3)
      expect(ids).to eq(['new', 'move', 'bar'])
      expect(returns).to eq(['Foo', 'void', 'int'])
      expect(param_idents.map(&:count)).to eq([0, 1, 2])
      expect(sub_body.count).to eq(3)
    end
  end

  describe "#compile_var_dec" do
    let(:input) {<<-EOF
      class Foo {
        function void bar() {
          var Array j;
          var int i, x;
        }
      }
      EOF
    }

    it "updates the doc" do
      #puts tokens.inspect
      eng.process!
      #puts doc.to_s.gsub(/></,">\n<")
      var_decs = doc.elements.to_a( "//varDec" )
      var_idents = var_decs.map {|var| var.elements.to_a("identifier") }.flatten.map(&:text)

      expect(var_decs.count).to eq(2)
      expect(var_idents).to eq(['Array','j','i','x'])
    end
  end

  describe "compile statements" do
    it "handles returns" do
      input = <<-EOF
        class Foo {
          function int bar() {
            return 0;
          }
        }
      EOF

      eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
      eng.process!

      statements = doc.elements.to_a( "//statements" )
      expect(statements.count).to eq(1)
      expect(statements.first.children.first.name).to eq('returnStatement')
      expect(statements.first.children.first.children.map(&:text)).to eq(['return', '0', ';'])
    end

    it "handles dos" do
      input = <<-EOF
        class Foo {
          function void bar() {
            do game.run(x, y);
            do game.empty();
          }
        }
      EOF

      eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
      eng.process!

      puts doc.to_s.gsub(/></,">\n<")
      statements = doc.elements.to_a( "//statements" )
      expect(statements.count).to eq(1)
      do_expr = statements.first.children.first
      expect(do_expr.name).to eq('doStatement')
      expect(do_expr.children.map(&:text).compact).to eq(['do', 'game', '.', 'run', '(', ')', ';'])
      expr_list = do_expr.elements.to_a('expressionList')
      expect(expr_list.count).to eq(1)
      exprs = expr_list.first.elements.to_a('expression')
      expect(exprs.count).to eq(2)
    end
  end
end
