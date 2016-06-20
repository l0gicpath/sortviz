module Sortviz
  class Canvas
    extend Forwardable
    def_delegators :@window, 
      :refresh, :clear, 
      :getch, :close, :attron, :attroff
    def_delegators :@cursor, :tprint

    MARGIN = 5
    attr_reader :window

    def initialize(title, cursor, screen_dim)
      @screen_dim = screen_dim
      @cursor = cursor
      @title = title
      @red_highlight = Curses.color_pair(Curses.const_get("COLOR_RED"))
      @window = nil
    end

    def setup
      @window = Curses::Window.new(
        @screen_dim[:lines] - MARGIN, 
        @screen_dim[:cols] - MARGIN,
        @cursor.y, @cursor.x)
      @window.box('|', '-')
      @window.nodelay = 1 # Non-blocking mode for #getch
    end

    def redraw(partially_sorted, selected_indx)
      @window.clear
      @window.box('|', '-')
      
      @cursor.move(0, 0)
      @cursor.tprint("Algorithm: #{@title}")

      len = partially_sorted.join.center(4).length
      @cursor.move(@window.maxy - 1, (@window.maxx - len) / MARGIN)
      
      partially_sorted.each_with_index do |n, i|
        tprint(("|%02d|" % n))

        @cursor.decr_y

        draw_bar(n, selected_indx == i)

        @cursor.move_y(@window.maxy - 1)
        @cursor.incr_x MARGIN
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