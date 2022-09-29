require_relative 'node'
require 'pry-byebug'

class Tree
  def initialize(arr)
    sorted_array = sort(arr)
    nice_array = clean(sorted_array)
    @root = build_tree(nice_array)
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
end

cool_array = []

(1..128).each do |i|
  cool_array << i
end

Tree.new(cool_array).pretty_print
