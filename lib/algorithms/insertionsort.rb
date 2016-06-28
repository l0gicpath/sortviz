Sortviz::Algorithms.define 'Insertion Sort' do
  author 'Emad Elsaid'
  url 'https://coderwall.com/p/z8vowg/simple-sorting-algorithms-with-ruby'
  name :'insertion-sort'

  sort -> (unsorted_list) {
    (1...unsorted_list.size).each do |i|
      j = i
      while j > 0 and unsorted_list[j-1] > unsorted_list[j]
        unsorted_list.swap!(j, j-1)
        j = j - 1
      end
    end
    return unsorted_list
  }
end