module Sortviz
  extend self
  ALGORITHMS = {}

  def define_algorithm(name, func_name)
    ALGORITHMS[func_name] = name
    module_function func_name
  end
end