Sortviz.Algorithms.define do
  display_name 'Insertion Sort'
  author 'Emad Elsaid'
  url 'https://coderwall.com/p/z8vowg/simple-sorting-algorithms-with-ruby'
  name :'insertion-sort'

  sort do |unsorted_list|
    (1...unsorted_list.size).each do |i|
      j = i
      while j > 0 and unsorted_list[j-1] > unsorted_list[j]
        unsorted_list[j], unsorted_list[j-1] = unsorted_list[j-1], unsorted_list[j]
        j = j - 1
        yield unsorted_list, j
      end
    end
  end
end