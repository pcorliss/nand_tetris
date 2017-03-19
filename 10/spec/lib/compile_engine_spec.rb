require './lib/compile_engine.rb'
require './lib/tokenizer.rb'
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
      returns = subs.map { |s| s.children.select {|e| ['identifier','keyword'].include? e.name }[1] }.flatten
      returns_names = returns.map(&:name)
      returns_vals = returns.map(&:text)
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
      expect(returns_vals).to eq(['Foo', 'void', 'int'])
      expect(returns_names).to eq(['identifier', 'keyword', 'keyword'])
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
    context "returns" do
      it "handles returns" do
        input = <<-EOF
          class Foo {
            function int bar() {
              return;
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!

        #puts eng.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
        statements = doc.elements.to_a( "//statements" )
        expect(statements.count).to eq(1)

        return_statement = statements.first.children.first
        expect(statements.first.children.first.name).to eq('returnStatement')
        expected = <<-EOF
<returnStatement>
<keyword>return</keyword>
<symbol>;</symbol>
</returnStatement>
        EOF
        expect(return_statement.to_s.gsub('><',">\n<") + "\n").to eq(expected)
      end

      it "handles expression returns" do
        input = <<-EOF
          class Foo {
            function int bar() {
              return x;
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!

        #puts eng.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
        statements = doc.elements.to_a( "//statements" )
        expect(statements.count).to eq(1)
        return_statement = statements.first.children.first
        expect(statements.first.children.first.name).to eq('returnStatement')
        expected = <<-EOF
<returnStatement>
<keyword>return</keyword>
<expression>
<term>
<identifier>x</identifier>
</term>
</expression>
<symbol>;</symbol>
</returnStatement>
      EOF
        expect(return_statement.to_s.gsub('><',">\n<") + "\n").to eq(expected)

      end

      it "leaves the stack in good shape" do
        input = <<-EOF
          class Foo {
            function int bar() {
              return;
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!

        #puts eng.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
        expect(doc.root.children.last.text).to eq('}')
      end
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

    child_terms = if_expr.children.map do |e|
      [e.name, e.text]
    end
    expected_terms = [
      ['keyword', 'if'],
      ['symbol', '('],
      ['expression', nil],
      ['symbol', ')'],
      ['symbol', '{'],
      ['statements', nil],
      ['symbol', '}'],
      ['keyword', 'else'],
      ['symbol', '{'],
      ['statements', nil],
      ['symbol', '}'],
    ]
    expect(child_terms).to eq(expected_terms)

    exprs = if_expr.elements.to_a('expression')
    expect(exprs.count).to eq(1)
    terms = exprs.first.elements.to_a('term')
    expect(terms.count).to eq(1)
  end

  describe "exrpressionless" do
    def strip_whitespace(str)
      str.gsub!(/\s+/, '')
      str
    end

    let(:main_fh)                 { File.open('spec/fixtures/ExpressionLessSquare/Main.jack') }
    let(:square_fh)               { File.open('spec/fixtures/ExpressionLessSquare/Square.jack') }
    let(:square_game_fh)          { File.open('spec/fixtures/ExpressionLessSquare/SquareGame.jack') }
    let(:main_expected)        { strip_whitespace(File.read('spec/fixtures/ExpressionLessSquare/Main.xml')).gsub(/></,">\n<") }
    let(:square_expected)      { strip_whitespace(File.read('spec/fixtures/ExpressionLessSquare/Square.xml')).gsub(/></,">\n<") }
    let(:square_game_expected) { strip_whitespace(File.read('spec/fixtures/ExpressionLessSquare/SquareGame.xml')).gsub(/></,">\n<") }


    it "has identical output for main" do
      t = Tokenizer.new(main_fh)
      t.strip!
      ce = CompileEngine.new(t.types, doc)
      ce.process!
      #m = strip_whitespace(doc.to_s).gsub(/></,">\n<")
      m = ce.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
      #puts m
      expect(m).to eq(main_expected)
    end

    it "has identical output for square" do
      t = Tokenizer.new(square_fh)
      t.strip!
      ce = CompileEngine.new(t.types, doc)
      ce.process!
      #m = strip_whitespace(doc.to_s).gsub(/></,">\n<")
      m = ce.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
      #puts m
      expect(m).to eq(square_expected)
    end

    it "has identical output for square_game" do
      t = Tokenizer.new(square_game_fh)
      t.strip!
      ce = CompileEngine.new(t.types, doc)
      ce.process!
      #m = strip_whitespace(doc.to_s).gsub(/></,">\n<")
      m = ce.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
      #puts m
      expect(m).to eq(square_game_expected)
    end
  end

  describe "expressions" do
    def strip_whitespace(str)
      str.gsub!(/\s+/, '')
      str
    end

    def prepare(str)
      strip_whitespace(str).gsub(/></,">\n<")
    end

    let(:main_fh)                 { File.open('spec/fixtures/Square/Main.jack') }
    let(:square_fh)               { File.open('spec/fixtures/Square/Square.jack') }
    let(:square_game_fh)          { File.open('spec/fixtures/Square/SquareGame.jack') }
    let(:main_expected)           { prepare(File.read('spec/fixtures/Square/Main.xml'))}
    let(:square_expected)         { prepare(File.read('spec/fixtures/Square/Square.xml'))}
    let(:square_game_expected)    { prepare(File.read('spec/fixtures/Square/SquareGame.xml'))}

    describe "components" do
      it "handles let statements with function calls" do
        expected = <<-EOF
          <letStatement>
            <keyword> let </keyword>
            <identifier> game </identifier>
            <symbol> = </symbol>
            <expression>
              <term>
                <identifier> SquareGame </identifier>
                <symbol> . </symbol>
                <identifier> new </identifier>
                <symbol> ( </symbol>
                <expressionList/>
                <symbol> ) </symbol>
              </term>
            </expression>
            <symbol> ; </symbol>
          </letStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              let game = SquareGame.new();
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//letStatement').first.to_s
        expect(prepare(m)).to eq(prepare(expected))
      end

      it "handles let statements with array indexing on the right hand side" do
        expected = <<-EOF
          <letStatement>
            <keyword> let </keyword>
            <identifier> a </identifier>
            <symbol> [ </symbol>
            <expression>
              <term>
                <integerConstant> 1 </integerConstant>
              </term>
            </expression>
            <symbol> ] </symbol>
            <symbol> = </symbol>
            <expression>
              <term>
                <identifier> a </identifier>
                <symbol> [ </symbol>
                <expression>
                  <term>
                    <integerConstant> 2 </integerConstant>
                  </term>
                </expression>
                <symbol> ] </symbol>
              </term>
            </expression>
            <symbol> ; </symbol>
          </letStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              let a[1] = a[2];
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//letStatement').first.to_s
        expect(prepare(m)).to eq(prepare(expected))
      end


      it "handles let statements with math and negatives" do
        expected = <<-EOF
          <letStatement>
            <keyword> let </keyword>
            <identifier> i </identifier>
            <symbol> = </symbol>
            <expression>
              <term>
                <identifier> i </identifier>
              </term>
              <symbol> * </symbol>
              <term>
                <symbol> ( </symbol>
                <expression>
                  <term>
                    <symbol> - </symbol>
                    <term>
                      <identifier> j </identifier>
                    </term>
                  </term>
                </expression>
                <symbol> ) </symbol>
              </term>
            </expression>
            <symbol> ; </symbol>
          </letStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              let i = i * (-j);
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//letStatement').first.to_s
        expect(prepare(m)).to eq(prepare(expected))
      end

      it "handles let statements with booleans" do
        expected = <<-EOF
          <letStatement>
            <keyword> let </keyword>
            <identifier> i </identifier>
            <symbol> = </symbol>
            <expression>
              <term>
                <identifier> i </identifier>
              </term>
              <symbol> | </symbol>
              <term>
                <identifier> j </identifier>
              </term>
            </expression>
            <symbol> ; </symbol>
          </letStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              let i = i | j;
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//letStatement').first.to_s
        expect(prepare(m)).to eq(prepare(expected))
      end

      it "handles while statements with unary ops" do
        expected = <<-EOF
          <whileStatement>
            <keyword> while </keyword>
            <symbol> ( </symbol>
            <expression>
              <term>
                <symbol> ~ </symbol>
                <term>
                  <identifier> exit </identifier>
                </term>
              </term>
            </expression>
            <symbol> ) </symbol>
            <symbol> { </symbol>
            <statements/>
            <symbol> } </symbol>
          </whileStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              while (~exit) {}
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//whileStatement').first.to_s
        expect(prepare(m)).to eq(prepare(expected))
      end

      it "handles while statements with unary ops and equality" do
        expected = <<-EOF
          <whileStatement>
            <keyword> while </keyword>
            <symbol> ( </symbol>
            <expression>
              <term>
                <symbol> ~ </symbol>
                <term>
                  <symbol> ( </symbol>
                  <expression>
                    <term>
                      <identifier> key </identifier>
                    </term>
                    <symbol> = </symbol>
                    <term>
                      <integerConstant> 0 </integerConstant>
                    </term>
                  </expression>
                  <symbol> ) </symbol>
                </term>
              </term>
            </expression>
            <symbol> ) </symbol>
            <symbol> { </symbol>
            <statements/>
            <symbol> } </symbol>
          </whileStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              while (~(key = 0)) {}
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//whileStatement').first.to_s
        #puts m
        expect(prepare(m)).to eq(prepare(expected))
      end

      it "handles do statements with expressions and expression lists" do
        expected = <<-EOF
          <doStatement>
            <keyword> do </keyword>
            <identifier> Screen </identifier>
            <symbol> . </symbol>
            <identifier> drawRectangle </identifier>
            <symbol> ( </symbol>
            <expressionList>
              <expression>
                <term>
                  <identifier> x </identifier>
                </term>
              </expression>
              <symbol> , </symbol>
              <expression>
                <term>
                  <identifier> y </identifier>
                </term>
              </expression>
              <symbol> , </symbol>
              <expression>
                <term>
                  <identifier> x </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <identifier> size </identifier>
                </term>
              </expression>
              <symbol> , </symbol>
              <expression>
                <term>
                  <identifier> y </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <identifier> size </identifier>
                </term>
              </expression>
            </expressionList>
            <symbol> ) </symbol>
            <symbol> ; </symbol>
          </doStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              do Screen.drawRectangle(x, y, x + size, y + size);
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//doStatement').first.to_s
        #puts m
        expect(prepare(m)).to eq(prepare(expected))
      end

      it "handles if statements with complicated expressions" do
        expected = <<-EOF
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <symbol> ( </symbol>
                  <expression>
                    <term>
                      <identifier> y </identifier>
                    </term>
                    <symbol> + </symbol>
                    <term>
                      <identifier> size </identifier>
                    </term>
                  </expression>
                  <symbol> ) </symbol>
                </term>
                <symbol> &lt; </symbol>
                <term>
                  <integerConstant> 254 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
            </term>
            <symbol> &amp; </symbol>
            <term>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <symbol> ( </symbol>
                  <expression>
                    <term>
                      <identifier> x </identifier>
                    </term>
                    <symbol> + </symbol>
                    <term>
                      <identifier> size </identifier>
                    </term>
                  </expression>
                  <symbol> ) </symbol>
                </term>
                <symbol> &lt; </symbol>
                <term>
                  <integerConstant> 510 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements/>
          <symbol> } </symbol>
        </ifStatement>
        EOF
        input = <<-EOF
          class Foo {
            function void bar() {
              if(((y + size) < 254) & ((x + size) < 510)) {}
            }
          }
        EOF

        eng = CompileEngine.new(Tokenizer.new(StringIO.new(input)).types, doc)
        eng.process!
        m = doc.elements.to_a('//ifStatement').first.to_s
        #puts m
        expect(prepare(m)).to eq(prepare(expected))
      end
    end

    it "has identical output for main" do
      t = Tokenizer.new(main_fh)
      t.strip!
      ce = CompileEngine.new(t.types, doc)
      ce.process!
      m = ce.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
      #puts m
      expect(m).to eq(main_expected)
    end

    it "has identical output for square" do
      t = Tokenizer.new(square_fh)
      t.strip!
      ce = CompileEngine.new(t.types, doc)
      ce.process!
      m = ce.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
      #puts m
      expect(m).to eq(square_expected)
    end

    it "has identical output for square_game" do
      t = Tokenizer.new(square_game_fh)
      t.strip!
      ce = CompileEngine.new(t.types, doc)
      ce.process!
      m = ce.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
      #puts m
      expect(m).to eq(square_game_expected)
    end
  end
end
