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

      #puts doc.to_s.gsub(/></,">\n<")
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

    it "handles lets" do
      input = <<-EOF
        class Foo {
          function void bar() {
            let a = b;
          }
        }
      EOF

      eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
      eng.process!

      #puts doc.to_s.gsub(/></,">\n<")
      statements = doc.elements.to_a( "//statements" )
      expect(statements.count).to eq(1)
      let_expr = statements.first.children.first
      expect(let_expr.name).to eq('letStatement')
      expect(let_expr.children.map(&:text).compact).to eq(['let','a','=',';'])
      exprs = let_expr.elements.to_a('expression')
      expect(exprs.count).to eq(1)
    end

    it "handles lets with simple array assignment" do
      input = <<-EOF
        class Foo {
          function void bar() {
            let a[i] = j;
          }
        }
      EOF

      eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
      eng.process!

      #puts doc.to_s.gsub(/></,">\n<")
      statements = doc.elements.to_a( "//statements" )
      expect(statements.count).to eq(1)
      let_expr = statements.first.children.first
      expect(let_expr.name).to eq('letStatement')
      expect(let_expr.children.map(&:text).compact).to eq(['let','a','[',']','=',';'])
      exprs = let_expr.elements.to_a('expression')
      expect(exprs.count).to eq(2)
    end

    it "handles lets with more complex post = terms" do
      input = <<-EOF
        class Foo {
          function void bar() {
            let a = j | b;
          }
        }
      EOF

      eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
      eng.process!

      #puts doc.to_s.gsub(/></,">\n<")
      statements = doc.elements.to_a( "//statements" )
      expect(statements.count).to eq(1)
      let_expr = statements.first.children.first
      expect(let_expr.name).to eq('letStatement')
      expect(let_expr.children.map(&:text).compact).to eq(['let','a','=',';'])
      exprs = let_expr.elements.to_a('expression')
      expect(exprs.count).to eq(1)
      terms = exprs.first.elements.to_a('term')
      expect(terms.count).to eq(2)
      syms = exprs.first.elements.to_a('symbol')
      expect(syms.count).to eq(1)
    end
  end

  it "handles while statements" do
    input = <<-EOF
      class Foo {
        function void bar() {
          while(true) {
            let a = 0;
            let b = 0;
          }
        }
      }
    EOF

    eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
    eng.process!

    #puts doc.to_s.gsub(/></,">\n<")
    statements = doc.elements.to_a( "//statements" )
    expect(statements.count).to eq(2)
    while_expr = statements.first.children.first
    expect(while_expr.name).to eq('whileStatement')
    expect(while_expr.children.map(&:text).compact).to eq(['while','(',')','{','}'])
    exprs = while_expr.elements.to_a('expression')
    expect(exprs.count).to eq(1)
    terms = exprs.first.elements.to_a('term')
    expect(terms.count).to eq(1)

    # Needs to handle nesting in the while statement
    expect(statements[1].elements.to_a('letStatement').count).to eq(2)
  end

  it "handles if/else statements" do
    input = <<-EOF
      class Foo {
        function void bar() {
          if(true) {
            let a = 0;
          } else {
            let b = 1;
          }
        }
      }
    EOF

    eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
    eng.process!

    #puts doc.to_s.gsub(/></,">\n<")
    if_statements = doc.elements.to_a( "//ifStatement" )
    expect(if_statements.count).to eq(1)
    if_expr = if_statements.first

    expect(if_expr.name).to eq('ifStatement')
    expect(if_expr.children.map(&:text).compact).to eq(['if','(',')','{','}','else','{','}'])
    exprs = if_expr.elements.to_a('expression')
    expect(exprs.count).to eq(1)
    terms = exprs.first.elements.to_a('term')
    expect(terms.count).to eq(1)
  end

  #describe "exrpressionless" do
    #def strip_whitespace(str)
      #str.gsub!(/\s+/, '')
    #end

    #eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
    #eng.process!
    #let(:main)                { strip_whitespace CompileEngine.new(Tokenizer.new(File.open('spec/fixtures/ExpressionLessSquare/Main.jack')).types, doc).process!;doc.to_s }
    #let(:square)              { strip_whitespace CompileEngine.new(Tokenizer.new(File.open('spec/fixtures/ExpressionLessSquare/Square.jack')).types, doc).process!;doc.to_s }
    #let(:squer_game)          { strip_whitespace CompileEngine.new(Tokenizer.new(File.open('spec/fixtures/ExpressionLessSquare/SqaureGame.jack')).types, doc).process!;doc.to_s }
    #let(:main_expected)       { strip_whitespace(File.read('spec/fixtures/ExpressionLessSquare/Main.xml')) }
    #let(:square_expected)     { strip_whitespace(File.read('spec/fixtures/ExpressionLessSquare/Square.xml')) }
    #let(:squer_game_expected) { strip_whitespace(File.read('spec/fixtures/ExpressionLessSquare/SquareGame.xml')) }


    #it "has identical output for main" do
      #expect(main).to eq(main_expected)
    #end
    #it "has identical output for square" do
      #expect(square).to eq(square_expected)
    #end
    #it "has identical output for square_game" do
      #expect(square_game).to eq(square_game_expected)
    #end
  #end
end
