module Sortviz
  class Canvas
    extend Forwardable
    def_delegators :@window, 
      :refresh, :clear, 
      :getch, :close, :attron, :attroff

    CANVAS_HEIGHT = 20  # That's our drawing area
    CANVAS_GUTTER = 50  # We subtract this value from Curses.cols
    GUTTER = 5
    GRAY_COLOR = 8

    attr_reader :window

    def initialize(cursor, screen_dim)
      @screen_dim = screen_dim
      @cursor = cursor
      # Cache red since we'll use it to highlight later, best do it now
      @red_highlighter = Curses.color_pair(Curses.const_get("COLOR_RED"))
      @gray_highlighter = Curses.color_pair(GRAY_COLOR)
      @window = nil
    end

    def setup
      @window = Curses::Window.new(
        @cursor.y + CANVAS_HEIGHT, 
        @screen_dim[:cols] - CANVAS_GUTTER,
        @cursor.y, @cursor.x)
      @window.box('|', '-')
      # Update our y-position to reflect the addition of canvas and its height
      @cursor.incr_y CANVAS_HEIGHT + 4
      @window.nodelay = 1 # Non-blocking mode for #getch
    end

    def redraw(partially_sorted, selected_indx)
      @window.clear
      @window.box('|', '-')
      @cursor.move(CANVAS_HEIGHT + 2, GUTTER)

      partially_sorted.each_index do |i|
        
        attron(@gray_highlighter)
        tprint(("|%02d|" % partially_sorted[i]))
        attroff(@gray_highlighter)
        @cursor.decr_y


        attron(@red_highlighter) if selected_indx + 1  == i
        partially_sorted[i].times do 
          tprint("|_ |")
          @cursor.decr_y
        end
        attroff(@red_highlighter)

        @cursor.move_y(CANVAS_HEIGHT + 2)
        @cursor.incr_x GUTTER
      end
    end

    private
    def tprint(string)
      window = @cursor.window
      window.addstr(string)
    end
  end
end