module Sortviz
  # insertion_sort is brought in from
  # https://coderwall.com/p/z8vowg/simple-sorting-algorithms-with-ruby  
  def insertionsort(list)
    (1...list.size).each do |i|
      j = i
      while j > 0 and list[j-1] > list[j]
        list[j], list[j-1] = list[j-1], list[j]
        j = j - 1
        yield list, j
      end
    end
  end

  define_algorithm "Insertion Sort", :insertionsort
end