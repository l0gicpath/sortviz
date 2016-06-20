module Sortviz
  class Canvas
    extend Forwardable
    def_delegators :@window, 
      :refresh, :clear, 
      :getch, :close, :attron, :attroff
    def_delegators :@cursor, :tprint

    CANVAS_HEIGHT = 20  # That's our drawing area
    CANVAS_GUTTER = 50  # We subtract this value from Curses.cols
    GUTTER = 5

    attr_reader :window

    def initialize(title, cursor, screen_dim)
      @screen_dim = screen_dim
      @cursor = cursor
      @title = title
      # Cache red since we'll use it to highlight later, best do it now
      @red_highlight = Curses.color_pair(Curses.const_get("COLOR_RED"))
      @window = nil
    end

    def setup
      @window = Curses::Window.new(
        @screen_dim[:lines] - GUTTER, 
        @screen_dim[:cols] - GUTTER,
        @cursor.y, @cursor.x)
      @window.box('|', '-')
      # Update our y-position to reflect the addition of canvas and its height
      @cursor.incr_y CANVAS_HEIGHT + 4
      @window.nodelay = 1 # Non-blocking mode for #getch
    end

    def redraw(partially_sorted, selected_indx)
      @window.clear
      @window.box('|', '-')
      @cursor.move(0, 0)
      @cursor.tprint("Algorithm: #{@title}")
      @cursor.move(CANVAS_HEIGHT + 2, GUTTER)
      partially_sorted.each_with_index do |n, i|
        tprint(("|%02d|" % n))

        @cursor.decr_y


        # attron(@red_highlighter) if selected_indx == i
        draw_bar(n, selected_indx == i)
        # attroff(@red_highlighter)

        @cursor.move_y(CANVAS_HEIGHT + 2)
        @cursor.incr_x GUTTER
      end
    end
    private
    def draw_bar(height, highlighted)
      attr = highlighted ? @red_highlight : Curses::A_REVERSE
      @window.attron(attr)
      height.times do
        @window.addstr(" ".center(4)) # 4 spaces
        @cursor.decr_y
      end
      @window.attroff(attr)
    end
  end
end