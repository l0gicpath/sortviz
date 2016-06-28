Sortviz::Algorithms.define 'Selection Sort' do
  author 'Emad Elsaid'
  url 'https://coderwall.com/p/z8vowg/simple-sorting-algorithms-with-ruby'
  name :'selection-sort'

  sort -> (unsorted_list) {
    (0...unsorted_list.size).each do |j|
      # find index of minimum element in the unsorted part 
      iMin = j
      (j+1...unsorted_list.size).each do |i|
        iMin = i if unsorted_list[i] < unsorted_list[iMin]
      end
      # then swap it
      unsorted_list.swap!(j, iMin)
    end
    return unsorted_list
  }
end