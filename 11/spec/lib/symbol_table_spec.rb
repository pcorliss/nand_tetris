require 'rspec'
require './lib/symbol_table.rb'

describe SymbolTable do
  let (:st) { SymbolTable.new }

  describe "get and set" do
    it "sets a symbol" do
      st.set('varname', 'int', 'ARG')
      expect(st.get('varname').name).to eq('varname')
      expect(st.get('varname').type).to eq('int')
      expect(st.get('varname').kind).to eq('ARG')
      expect(st.get('varname').offset).to eq(0)
    end

    it "increments the offset" do
      st.set('varname', 'int', 'ARG')
      st.set('varname2', 'int', 'ARG')
      st.set('varname3', 'int', 'ARG')
      expect(st.get('varname').offset).to eq(0)
      expect(st.get('varname2').offset).to eq(1)
      expect(st.get('varname3').offset).to eq(2)
    end

    it "doesn't increment for different kind" do
      st.set('varname', 'int', 'ARG')
      st.set('varname2', 'int', 'STATIC')
      st.set('varname3', 'int', 'FIELD')
      st.set('varname4', 'int', 'VAR')
      expect(st.get('varname').offset).to eq(0)
      expect(st.get('varname2').offset).to eq(0)
      expect(st.get('varname3').offset).to eq(0)
      expect(st.get('varname4').offset).to eq(0)
    end

    it "throws an error if the kind is invalid" do
      expect do
        st.set('varname', 'int', 'FOO')
      end.to raise_error(RuntimeError, "Invalid kind: FOO")
    end
  end

  describe "#exists?" do
    it "returns true if the symbol exists" do
      st.set('varname', 'int', 'ARG')
      expect(st.exists?('varname')).to be_truthy
    end

    it "returns false if the symbol does not exist" do
      st.set('varname', 'int', 'ARG')
      expect(st.exists?('fake')).to be_falsey
    end
  end

  describe "#count" do
    it "returns the number of values of the specified kind" do
      st.set('varname', 'int', 'ARG')
      st.set('varname2', 'int', 'ARG')
      st.set('varname3', 'int', 'VAR')
      expect(st.count('ARG')).to eq(2)
    end

    it "returns the total number of values" do
      st.set('varname', 'int', 'ARG')
      st.set('varname2', 'int', 'ARG')
      st.set('varname3', 'int', 'VAR')
      expect(st.count).to eq(3)
    end
  end
end
