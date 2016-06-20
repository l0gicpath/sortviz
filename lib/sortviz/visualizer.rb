module Sortviz
  # Visualizer is the entry point of Sortviz, given an algorithm name it'll
  # initialize Curses library, a +Sortviz::Canvas+ with proper screen dimensions
  # and a +Sortviz::Cursor+.
  #
  # It also generates a shuffled list of numbers counting from 1 to n, n is 
  # decided by Sortviz::Visualizer#generate_list which calculates the number
  # of bar charts that can be drawn given the current screen size.
  #
  # _Notice_: Curses coordinates are treated in reverse, (y, x) and x represents
  # the number of columns, y represents the number of lines so
  # *(y, x)* is *(cols, lines)*. As a result of that we too, use _(y, x)_.
  class Visualizer
    # Origin starts at (1, 0) not 
    ORIGIN = { y: 1, x: 5 }
    SLEEP_INTERVAL = 0.005

    # Initializes a new Visualizer for a sorting algorithm
    # Params:
    # +algo+:: +Symbol+ A symbol representing a sorting algorithm method
    def initialize(algo)
      setup_curses
      @screen_dim = { cols: Curses.cols - ORIGIN[:x], lines: Curses.lines }
      @screen     = Curses.stdscr
      @cursor     = Cursor.new(@screen, ORIGIN)
      @canvas     = Canvas.new(ALGORITHMS[algo], @cursor, @screen_dim)

      @algo       = algo
      @unsorted_list = generate_list
    end

    # Starts the actual visualization
    # * First prints the program's banner
    # * Sets up the canvas (+Sortviz::Canvas+)
    # * Caches the cursor location so we can return to our original location later
    # * Refreshes the current standard screen first
    # * Refreshes the canvas
    # * Finally we switch input to the canvas through +Sortviz::Cursor#switch_window+
    #
    # The order is important because curses works in such a way that the last
    # thing on display is the last thing refreshed, if we had refreshed canvas
    # first, it would have been drawn normally, then we refresh the standard
    # screen (in which the canvas is inside) it'll do just that refreshs and overrides the canvas.
    #
    # === The loop
    # In order to draw every returned partially sorted list from the algorithm method
    # we have to loop, clearing the canvas everytime and redrawing it then telling
    # Curses to apply these drawn updates. This helps with flicker but I still
    # seem to be getting some of it ever since I introduced the +Curses::A_REVERSE+
    # attribute.
    #
    # Durring the loop, we're trapped inside the sorting method, as a block of code
    # that gets yielded to on every iteration of the sorting algorithm. To exit that
    # at anytime during the sorting run, we capture the keyboard and return if any key is pressed,
    # the canvas has +Curses::Window#getch+ on non-block mode so it doesn't block waiting for a character.
    #
    # Finally, we make sure both the canvas and the standard screen are closed.
    # It's important to note that we also poll on keyboard after we exit the sorting method.
    # In order to allow the user a moment to see the final sorted graph.
    def visualize
      begin
        banner
        @canvas.setup
        @cursor.cache

        @screen.refresh
        @canvas.refresh
        
        @cursor.switch_window @canvas.window

        loop do
           Sortviz.send(@algo, @unsorted_list) do |partially_sorted, selected_indx|
            @canvas.redraw(partially_sorted, selected_indx)
            Curses.doupdate
            sleep SLEEP_INTERVAL
            return if @canvas.getch
           end
          @cursor.switch_window @screen # Switch back to our stdscr
          @cursor.restore # Restoring here, would place us right under the canvas box
          @cursor.newline
          @cursor.tprint("Press any key to exit")
          break if Curses.getch
        end
      ensure
        @canvas.close
        Curses.close_screen
      end
    end

    private
    def setup_curses
      Curses.init_screen
      Curses.noecho
      Curses.curs_set(0)        # Hide cursor
      Curses.start_color        # Kick off colored output
      Curses.use_default_colors

      # We only need Red
      Curses.init_pair(Curses::COLOR_RED, -1, Curses::COLOR_RED)
    end

    # We want to know how much can we draw depending on the window size
    # To do that, we know that a single bar takes up 4 columns '|00|'' (bar_len)
    # We also know that we add 5 columns between bars (Canvas::MARGIN)
    # So we take cols/bar_len + CANVAS::MARGIN = n_bars
    def generate_list
      n = @screen_dim[:cols] / (4 + Canvas::MARGIN)
      (1..n).to_a.shuffle
    end

    def banner
      @cursor.tap do |c|
        c.tprint("-----------------------------------------------------------------")
        c.newline
        c.tprint("SortViz: Sorting Algorithms Visualization, Ruby & Curses - v#{VERSION}")
        c.newline
        c.tprint("-----------------------------------------------------------------")
        c.newline
      end
    end

  end
end