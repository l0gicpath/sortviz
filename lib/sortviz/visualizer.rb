module Sortviz
  # Visualizer is the entry point of our Terminal UI. That's where all the juice
  # happens. It initializes the curses library, visualizes sorting, 
  # cleans up after we're done and controls the event loop.
  class Visualizer
    ORIGIN = { y: 1, x: 5 }
    SLEEP_INTERVAL = 0.005

    def initialize(algo)
      setup_curses
      # Cache our dimensions, helpful in calculations
      @screen_dim = { cols: Curses.cols - ORIGIN[:x], lines: Curses.lines }
      # Take Reference for Curses initial standard window
      @screen     = Curses.stdscr
      @cursor     = Cursor.new(@screen, ORIGIN)
      @canvas     = Canvas.new(ALGORITHMS[algo], @cursor, @screen_dim)

      @algo       = algo
      @unsorted_list = generate_list
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
    # To do that, we know that a single bar takes up 4 columns |00| (bar-len)
    # We also know that we add tw5 columns between bars (Canvas::MARGIN)
    # So we take cols/bar-len + CANVAS::MARGIN = n_bars
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