require 'pry-byebug'

class Tree
  attr_reader :root

  def initialize(arr)
    @root = build_tree(arr)
  end

  def build_tree(array)
    sort(array).uniq!
  end

  def sort(array)
    length = array.size
    return array if length < 2

    left_half = sort(array[0...length / 2])
    right_half = sort(array[length / 2...length])
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

Tree.new([1, 5, 3, 6, 5, 2])
