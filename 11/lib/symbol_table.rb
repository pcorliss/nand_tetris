require 'set'

class SymbolTable
  Symbol = Struct.new(:name, :type, :kind, :offset)

  VALID_KINDS = Set.new(['ARG', 'STATIC', 'FIELD', 'VAR'])

  def initialize
    @symbols = {}
    @kind_counts = Hash.new(0)
  end

  def set(name, type, kind)
    kind = kind.upcase
    raise(RuntimeError, "Invalid kind: #{kind}") unless VALID_KINDS.include? kind
    @symbols[name] = Symbol.new(name, type, kind, @kind_counts[kind])
    @kind_counts[kind] += 1
  end

  def get(name)
    @symbols[name]
  end

  def exists?(name)
    @symbols.has_key? name
  end

  def count(kind)
    @kind_counts[kind.upcase]
  end
end
