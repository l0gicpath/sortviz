module Sortviz
  class Algorithms
    class << self
      def define(algorithm_name, &block)
        plugins << { display_name: algorithm_name }
        instance_eval &block
      end

      def plugins
        @plugins ||= []
      end

      def do_sort(index, unsorted_list, &renderblock)
        plugins[index][:sort].call(unsorted_list, &renderblock)
      end

      private

      def sort
        Algorithms.plugins.last[:sort] = Proc.new
      end

      def name(name)
        plugins.last[:name] = name
      end

      def author(author)
        plugins.last[:author] = author
      end

      def url(link)
        plugins.last[:url] = link
      end
    end
  end
end