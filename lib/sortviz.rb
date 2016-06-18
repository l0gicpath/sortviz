require 'curses'
require 'forwardable'
require 'sortviz/version'
require 'sortviz/cursor'
require 'sortviz/canvas'
require 'sortviz/visualizer'
require 'sortviz/plugins'

libdir = File.dirname(__FILE__) 
Dir[libdir + '/algorithms/*.rb'].each {|file| require file }

module Sortviz
  extend self
  def init(algo)
    unsorted_list = (1..20).to_a.shuffle
    visualizer = Visualizer.new unsorted_list, algo
    visualizer.visualize
  end
end