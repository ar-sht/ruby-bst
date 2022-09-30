require_relative 'node'
require 'pry-byebug'

class Tree
  def initialize(arr = nil)
    if arr.nil?
      @root = nil
      return
    end

    sorted_array = sort(arr)
    nice_array = clean(sorted_array)
    @root = build_tree(nice_array)
  end

  def get_root
    @root
  end

  def build_tree(array)
    # binding.pry
    return nil if array.empty?

    first = 0
    last = array.size - 1
    mid = (first + last) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array[first...mid])
    root.right = build_tree(array[(mid + 1)..last])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def clean(array)
    clean_arr = []
    array.each do |val|
      clean_arr << val unless clean_arr.include?(val)
    end
    clean_arr
  end

  def sort(array)
    length = array.size
    return array if length < 2

    left_half = sort(array[0...(length / 2)])
    right_half = sort(array[(length / 2)...length])
    merge(left_half, right_half)
  end

  def merge(arr1, arr2)
    merged_arr = []
    (arr1.size + arr2.size).times do
      if arr1.empty?
        merged_arr << arr2.shift
      elsif arr2.empty?
        merged_arr << arr1.shift
      else
        if arr1[0] <= arr2[0]
          merged_arr << arr1.shift
        else
          merged_arr << arr2.shift
        end
      end
    end
    merged_arr
  end

  def find(val, root = @root)
    search_node = Node.new(val)
    return nil if root.nil?
    return root if search_node == root

    if search_node > root
      find(val, root.right)
    else
      find(val, root.left)
    end
  end

  def insert(val)
    new_node = Node.new(val)
    current_node = @root
    if current_node.nil?
      @root = new_node
      return
    end

    until current_node.nil?
      return nil if new_node == current_node

      last_node = current_node
      current_node = new_node > last_node ? last_node.right : last_node.left
    end
    new_node > last_node ? last_node.right = new_node : last_node.left = new_node
  end

  def delete(val)
    to_delete = find(val)
    return nil if to_delete.nil?

    if to_delete.leaf?
      # TODO: find parent and pop from children
    elsif to_delete.children_count == 1
      # TODO: find parent and reassign child to child of to_delete
    else
      # TODO: find parent and reassign child to smallest/largest ancestor of largest lineage
    end
  end
end
cool_array = [4, 2, 5, 7]

test_tree = Tree.new(cool_array)
test_tree.pretty_print
test_tree.insert(6)
test_tree.insert(3)
test_tree.insert(7)
test_tree.insert(-45)
test_tree.pretty_print
p test_tree.get_root.children_count
p test_tree.get_root.descendants_count
