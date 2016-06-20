Sortviz.Algorithms.define do
  display_name 'Bubble Sort'
  author 'ieatkimchi'
  url 'https://github.com/ieatkimchi/Bubble_Sort_Ruby'
  name :'bubble-sort'

  sort do |unsorted_list|
    unsorted_list.each_index do |i|
      (unsorted_list.length - i - 1).times do |j|
        if unsorted_list[j] > unsorted_list[j + 1]
          unsorted_list[j], unsorted_list[j + 1] = unsorted_list[j + 1], unsorted_list[j]
        end
        yield unsorted_list, j + 1
      end
    end
  end
end