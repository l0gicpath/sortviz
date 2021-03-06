module Sortviz
  # Canvas is the portion of the screen that contains the sorting bar charts.
  # It displays the partially sorted list of numbers and redraws on every iteration
  # marking the currently selected bar (current index in the partially sorted list)
  class Canvas
    extend Forwardable
    def_delegators :@window, :refresh, :getch, :close, :attron, :attroff
    MARGIN = 5
    attr_reader :window

    # Initializes a new instance with a title to display, the current cursor
    # object (<tt>Sortviz::Cursor</tt>) and the modified screen dimensions from the
    # parent window/screen (standard screen created in <tt>Sortviz::Visualizer</tt>)
    def initialize(title, cursor, screen_dim)
      @screen_dim = screen_dim
      @cursor = cursor
      @title = title
      @red_highlight = Curses.color_pair(Curses.const_get("COLOR_RED"))
    end

    # Does the initial setup of creating an actual curses window, adding a 
    # border to it and setting up non-blocking <tt>Curses::Window#getch</tt>
    def setup
      @window ||= Curses::Window.new(
        @screen_dim[:lines] - MARGIN, 
        @screen_dim[:cols] - MARGIN,
        @cursor.y, @cursor.x)
      @window.nodelay = 1 # Non-blocking mode for #getch
    end

    # Draws the partially sorted list and highlights the current index
    # It also attempts to center the graph in the display area, does well but
    # not always, sometimes it'll be shifted to the right a bit.
    def draw(partially_sorted, selection)
      clear
      draw_title

      len = partially_sorted.join.center(4).length
      # We draw bottom up, this sets our y-position at the very bottom of
      # the canvas and our x-position half way through the canvas
      @cursor.move(@window.maxy - 1, (@window.maxx - len) / MARGIN)
      
      partially_sorted.each_with_index do |number, i|
        draw_number(number)
        draw_bar(number, i == selection)
        next_bar
      end
      
      Curses.doupdate
    end

    private

    def clear
      @window.clear
      @window.box('|', '-')
    end

    def draw_title
      @cursor.move(0, 0)
      @cursor.tprint("Algorithm: #{@title}")
    end

    def draw_number(number)
      @cursor.tprint(("|%02d|" % number))
      @cursor.decr_y
    end

    def draw_bar(height, highlighted)
      attr = highlighted ? @red_highlight : Curses::A_REVERSE
      attron(attr)
      height.times do
        @cursor.tprint(" ".center(4)) # 4 spaces
        @cursor.decr_y
      end
      attroff(attr)
    end

    def next_bar
      @cursor.move_y(@window.maxy - 1)
      @cursor.incr_x MARGIN
    end
  end
end