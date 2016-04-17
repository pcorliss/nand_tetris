require 'rspec'
require_relative 'asm.rb'

describe "dest_comp_jump" do
  {
    "D=0" => ['D','0',nil],
    "D=M" => ['D','M',nil],
    "D=M+1" => ['D','M+1',nil],
    "0;JMP" => [nil,'0','JMP'],
    "D=M;JMP" => ['D', 'M', 'JMP'],
  }.each do |inp, out|
    it "converts #{inp} to #{out}" do
      expect(dest_comp_jump(inp)).to eq(out)
    end
  end
end
