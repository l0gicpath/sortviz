module Sortviz
  # selection_sort is brought in from
  # https://coderwall.com/p/z8vowg/simple-sorting-algorithms-with-ruby
  def selectionsort(list)
    (0...list.size).each do |j|
      # find index of minimum element in the unsorted part 
      iMin = j
      (j+1...list.size).each do |i|
        iMin = i if list[i] < list[iMin]
      end

      # then swap it
      list[j], list[iMin] = list[iMin], list[j]
      yield list, iMin
    end
  end

  define_algorithm "Selection Sort", :selectionsort
end