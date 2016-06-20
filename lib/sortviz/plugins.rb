module Sortviz
  extend self
  ALGORITHMS = {}

  # Defines a new algorithm for sorting by adding some meta data to
  # <tt>Sortviz::ALGORITHMS</tt> and turning the sorting algorithm method into a
  # Module function of <tt>Sortviz</tt>.
  #
  # It's a bad design, should be fixed soon with a proper plugin system as this
  # way pollutes the Sortviz namespace.
  #
  # Params:
  # +name+:: <tt>String</tt> Name of the sorting algorithm for display purposes
  # +func_name+:: <tt>Symbol</tt> A symbol representation of the actual method that does
  # the actual sorting. It's important that both match or else <tt>Sortviz::Visualizer</tt>
  # will not be able to find it and call it.
  def define_algorithm(name, func_name)
    ALGORITHMS[func_name] = name
    module_function func_name
  end
end