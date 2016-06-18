module Sortviz
  
  def bubblesort(list)
    list.each_index do |i|
      (list.length - i - 1).times do |j|
        if list[j] > list[j + 1]
          list[j], list[j + 1] = list[j + 1], list[j]
        end
        yield list, j + 1
      end
    end
  end

  define_algorithm "Bubble Sort", :bubblesort
end