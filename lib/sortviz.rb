require 'curses'
require 'forwardable'
require 'sortviz/version'
require 'sortviz/cursor'
require 'sortviz/canvas'
require 'sortviz/visualizer'
require 'sortviz/plugins'

dir = './algorithms'
$LOAD_PATH.unshift(dir)
Dir[File.join(dir, '*.rb')].each {|file| require File.basename(file) }

module Sortviz
  extend self
  def init(algo)
    unsorted_list = (1..20).to_a.shuffle
    visualizer = Visualizer.new unsorted_list, algo
    visualizer.visualize
  end
end