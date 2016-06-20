module Sortviz
  extend self
  ALGORITHMS = {}

  # Defines a new algorithm for sorting by adding some meta data to
  # +Sortviz::ALGORITHMS+ and turning the sorting algorithm method into a
  # Module function of +Sortviz+.
  #
  # It's a bad design, should be fixed soon with a proper plugin system as this
  # way pollutes the Sortviz namespace.
  # Params:
  # +name+:: +String+ Name of the sorting algorithm for display purposes
  # +func_name+:: +Symbol+ A symbol representation of the actual method that does
  # the actual sorting. It's important that both match or else +Sortviz::Visualizer+
  # will not be able to find it and call it.
  def define_algorithm(name, func_name)
    ALGORITHMS[func_name] = name
    module_function func_name
  end
end