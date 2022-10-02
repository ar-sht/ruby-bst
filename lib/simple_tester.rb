require_relative 'tree'

test_tree = Tree.new(Array.new(15) { rand(1...100) })

puts test_tree.balanced? ? 'The tree is balanced.' : 'Something\'s gone terribly wrong, the tree\'s unbalanced!'

test_tree.pretty_print

(1001...1010).each { |val| test_tree.insert(val) }

puts test_tree.balanced? ? 'Something\'s gone terribly wrong, the tree is balanced!' : 'The tree is unbalanced.'
test_tree.pretty_print

test_tree.rebalance

puts test_tree.balanced? ? 'The tree\'s been re-balanced.' : 'Something\'s gone terribly wrong, the tree\'s still unbalanced!'

test_tree.pretty_print
