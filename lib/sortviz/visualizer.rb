module Sortviz
  # Visualizer is the entry point of our Terminal UI. That's where all the juice
  # happens. It initializes the curses library, visualizes sorting, 
  # cleans up after we're done and controls the event loop.
  class Visualizer
    extend Forwardable
    def_delegators :@cursor, :tprint, :newline 

    ORIGIN = { y: 1, x: 5 }
    SLEEP_INTERVAL = 0.005

    def initialize(unsorted_list, algo)
      setup_curses
      # Cache our dimensions, helpful in calculations
      @screen_dim = { cols: Curses.cols - ORIGIN[:x], lines: Curses.lines }
      # Take Reference for Curses initial standard window
      @screen     = Curses.stdscr
      @cursor     = Cursor.new(@screen, ORIGIN)
      @canvas     = Canvas.new(ALGORITHMS[algo], @cursor, @screen_dim)

      @algo       = algo
      @unsorted_list = unsorted_list
    end

    def visualize
      begin
        banner
        # NOTICE: :caveat: It's important to setup the canvas AFTER displaying
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
            Curses.doupdate
            sleep SLEEP_INTERVAL
            return if @canvas.getch
           end
          @cursor.switch_window @screen # Switch back to our stdscr
          @cursor.restore # Restoring here, would place us right under the canvas box
          newline
          tprint("Press 'q' to exit")
          break if Curses.getch == 'q'
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

      # We need Red
      Curses.init_pair(Curses::COLOR_RED, -1, Curses::COLOR_RED)
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