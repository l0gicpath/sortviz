module Sortviz
  # Visualizer is the entry point of our Terminal UI. That's where all the juice
  # happens. It initializes the curses library, visualizes sorting, 
  # cleans up after we're done and controls the event loop.
  class Visualizer
    extend Forwardable
    def_delegators :@cursor, :tprint, :newline 
    # All our rendering kicks off from these two values, consider them
    # our origin point instead of (0, 0)
    GUTTER = 5          # We don't want to flirt too much with the terminal border
    TOP_MARGIN = 1      # Same issue with the top border
    SLEEP_INTERVAL = 0.3

    def initialize(unsorted_list, algo)
      setup_curses
      # Cache our dimensions, helpful in calculations
      @screen_dim = { cols: Curses.cols, lines: Curses.lines }
      # Take Reference for Curses initial standard window
      @screen     = Curses.stdscr
      @cursor     = Cursor.new(@screen, TOP_MARGIN, GUTTER)
      @canvas     = Canvas.new(ALGORITHMS[algo], @cursor, @screen_dim)

      @algo       = algo
      @unsorted_list = unsorted_list
    end

    def visualize
      begin
        banner
        # NOTICE: :Cavet: It's important to setup the canvas AFTER displaying
        # the banner, so the canvas would correctly calculate its offsets
        # based on the current cursor position, as in, after printing banner
        @canvas.setup
        @cursor.cache # Cache our location before the visualization mess kicks in

        @screen.refresh
        @canvas.refresh
        
        @cursor.switch_window @canvas.window

        loop do
           Sortviz.send(@algo, @unsorted_list) do |partially_sorted, selected_indx|
            @canvas.redraw(partially_sorted, selected_indx)
            update
            return if @canvas.getch == 'q'
           end
          @canvas.close

          @cursor.switch_window @screen # Switch back to our stdscr
          @cursor.restore # Restoring here, would place us right under the canvas box
          newline
          tprint("Press 'q' to exit")
          break if Curses.getch == 'q'
        end
      ensure
        Curses.close_screen
      end
    end

    private
    def update
      # doupdate is much more efficient than multiple refreshes
      # and after some testing, it seems to clear out the flicker
      # caused by multiple rapid calls to refresh
      Curses.doupdate
      sleep SLEEP_INTERVAL
    end

    def setup_curses
      Curses.init_screen
      Curses.noecho       # As soon as we prep the terminal screen, stop echo
      Curses.nonl         # Line feeds and carriage return as well
      Curses.curs_set(0)        # Hide cursor
      Curses.start_color        # Kick off colored output
      Curses.use_default_colors

      # We need Red and Gray
      Curses.init_pair(Curses::COLOR_RED, Curses::COLOR_RED, -1)
      Curses.init_pair(8, 235, -1)
    end

    def banner
      tprint("-----------------------------------------------------------------")
      newline
      tprint("SortViz: Sorting Algorithms Visualization, Ruby & Curses - v#{VERSION}")
      newline
      tprint("-----------------------------------------------------------------")
      newline
    end

  end
end