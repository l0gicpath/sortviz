Sortviz::Algorithms.define 'Selection Sort' do
  author 'Emad Elsaid'
  url 'https://coderwall.com/p/z8vowg/simple-sorting-algorithms-with-ruby'
  name :'selection-sort'

  # sort do |unsorted_list|
  #   (0...unsorted_list.size).each do |j|
  #     # find index of minimum element in the unsorted part 
  #     iMin = j
  #     (j+1...unsorted_list.size).each do |i|
  #       iMin = i if unsorted_list[i] < unsorted_list[iMin]
  #     end

  #     # then swap it
  #     unsorted_list[j], unsorted_list[iMin] = unsorted_list[iMin], unsorted_list[j]
  #     yield unsorted_list, j
  #   end
  # end
end