require 'curses'
require "sortviz/version"
require "sortviz/cursor"
require "sortviz/canvas"
require "sortviz/visualizer"

module Sortviz
  # extend self

  def self.init
    unsorted_list = (1..20).to_a.shuffle
    visualizer = Visualizer.new unsorted_list
    visualizer.visualize
  end
end