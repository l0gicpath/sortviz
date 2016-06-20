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
    visualizer = Visualizer.new algo
    visualizer.visualize
  end
end