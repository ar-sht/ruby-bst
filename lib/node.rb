class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end

  def copy
    initialize(data, left, right)
  end

  def leaf?
    left.nil? && right.nil?
  end

  def children_count
    if leaf?
      0
    elsif !left.nil? && !right.nil?
      2
    else
      1
    end
  end

  def descendants_count(current_node = self)
    return 0 if current_node.nil? || current_node.leaf?

    current_node.children_count + descendants_count(current_node.left) + descendants_count(current_node.right)
  end

  def change_child(direction_symbol, new_val = nil)
    if direction_symbol == :left
      @left = new_val
    elsif direction_symbol == :right
      @right = new_val
    end
  end
end
