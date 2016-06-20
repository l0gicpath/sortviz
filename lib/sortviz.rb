require 'curses'
require 'forwardable'
require 'sortviz/version'
require 'sortviz/cursor'
require 'sortviz/canvas'
require 'sortviz/visualizer'
require 'sortviz/algorithms'

libdir = File.dirname(__FILE__) 
Dir[libdir + '/algorithms/*.rb'].each {|file| require file }

module Sortviz
  extend self

  def find_algorithm(algorithm)
    return nil if algorithm.nil?
    Algorithms.plugins.find_index { |plugin| plugin[:name] == algorithm.to_sym }
  end

  def init(args)
    visualizer = Visualizer.new args
    visualizer.visualize
  end
end