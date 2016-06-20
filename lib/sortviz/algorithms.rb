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

      private

      def sort(&sort_block)
        plugins.last[:sort] = sort_block
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