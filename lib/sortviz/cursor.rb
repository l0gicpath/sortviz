module Sortviz
  # Cursor represents a terminal cursor, can easily switch between
  # different windows (curses) and can remember the last cursor position it
  # was at.
  # This is to wrap up the boilerplate code of moving a cursor around a terminal
  # window
  class Cursor
    attr_reader :y, :x, :window
    # Initialize a new Cursor object, follows curses practice of passing
    # the y before the x coords.
    #
    # Params:
    # +window+:: <tt>Curses::Window</tt> The window that will receive input
    # +origin+:: <tt>Hash</tt> Origins to start drawing at
    def initialize(window, origin)
      @window = window
      move(origin[:y], origin[:x])
    end

    # Move to positions y, x
    def move(y, x)
      update(y, x)
      apply_pos
    end

    # Move along the y-axis
    def move_y(val)
      update(val, x)
      apply_pos
    end

    # Move along the x-axis
    def move_x(val)
      update(y, val)
      apply_pos
    end

    # Increment the y value by val (Default: 1)
    def incr_y(val = 1)
      update(y + val, x)
      apply_pos
    end

    # Decrement the y value by val (Default: 1)
    def decr_y(val = 1)
      update((y - val).abs, x)
      apply_pos
    end

    # Increment the x value by val (Default: 1)
    def incr_x(val = 1)
      update(y, x + val)
      apply_pos
    end

    # Decrement the x value by val (Default: 1)
    def decr_x(val = 1)
      update(y, (x - val).abs)
      apply_pos
    end

    # Cache the current cursor coordinates
    def cache
      @cached = { y: @y, x: @x }
    end

    # Restore the previously cached cursor coordinates if any are cached
    def restore
      return unless @cached
      update(@cached[:y], @cached[:x])
      @cached = nil
    end

    # Switch to a new window that will receive input and optionally move to
    # new coordinates in the new window
    def switch_window(new_window, coords: {})
      @window = new_window
      move(coords[:y], coords[:x]) unless coords.empty?
    end

    # Print to the current screen receiving input
    def tprint(string)
      @window.addstr(string)
    end

    # Increment y to simulate the addition of a new line
    def newline
      incr_y
    end

    private
    def update(y, x)
      @y, @x = y, x
    end

    def apply_pos
      window.setpos(@y, @x)
    end
  end
end