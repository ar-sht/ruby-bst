# frozen_string_literal: true
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
      merged_arr << if arr1.empty?
        arr2.shift
      elsif arr2.empty?
        arr1.shift
      elsif arr1[0] <= arr2[0]
        arr1.shift
        else
          arr2.shift
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

  def find_parent(node, root = @root)
    return nil if root.nil? || node.nil? || find(node.data).nil? || find(node.data) == root
    if root.left == node
      return [root, :left]
    elsif root.right == node
      return [root, :right]
    end

    if node > root
      find_parent(node, root.right)
    else
      find_parent(node, root.left)
    end
  end
  
  def find_min(root = @root)
    current_node = root
    current_node = current_node.left until current_node.left.nil?
    current_node
  end

  def find_max(root = @root)
    current_node = root
    current_node = current_node.right until current_node.right.nil?
    current_node
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
    parent_and_dir = find_parent(to_delete)
    return nil if to_delete.nil?
    if parent_and_dir.nil?
      if to_delete.leaf?
        @root = nil
      elsif to_delete.children_count == 1
        @root = to_delete.left.nil? ? to_delete.right : to_delete.left
      else
        to_assign = to_delete.left.descendants_count > to_delete.right.descendants_count ? find_max(to_delete.left) : find_min(to_delete.right)
        delete(to_assign.data)
        to_assign.left = to_delete.left
        to_assign.right = to_delete.right
        @root = to_assign
      end
      return
    end

    parent = parent_and_dir[0]
    direction = parent_and_dir[1]
    if to_delete.leaf?
      parent.change_child(direction)
    elsif to_delete.children_count == 1
      to_delete.left.nil? ? parent.change_child(direction, to_delete.right) : parent.change_child(direction, to_delete.left)
    else
      if to_delete.left.descendants_count > to_delete.right.descendants_count
        to_assign = find_max(to_delete.left)
        delete(to_assign.data)
        to_assign.right = to_delete.right
      else
        to_assign = find_min(to_delete.right)
        delete(to_assign.data)
        to_assign.left = to_delete.left
      end
      parent.change_child(direction, to_assign)
    end
  end
end
cool_array = []
10.times do
  cool_array << rand(50)
end

test_tree = Tree.new(cool_array)
test_tree.pretty_print

5.times do
  num = rand(100)
  test_tree.insert(num)
  puts "Inserting: #{num}"
end
test_tree.pretty_print

3.times do
  num = cool_array.sample
  test_tree.delete(num)
  puts "Deleting: #{num}"
end
test_tree.pretty_print

root = test_tree.get_root
puts "Deleting root: #{root.data}"
test_tree.delete(root.data)
test_tree.pretty_print
