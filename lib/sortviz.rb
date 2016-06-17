require 'curses'
require "sortviz/version"
require "sortviz/cursor"
require "sortviz/tui"

module Sortviz
  class VisualSorter
    def initialize
      setup
      @screen = Curses.stdscr
      @cursor = Sortviz::Cursor.new(@screen, 1, 5)
      run
    end

    def bubble_sort2(list)
      return list if list.size <= 1 # already sorted
      loop do
        swapped = false
        0.upto(list.size-2) do |i|
          if list[i] > list[i+1]
            list[i], list[i+1] = list[i+1], list[i] # swap values
            swapped = true
          end
          yield list, i
        end
        break unless swapped
      end
      list
    end

    def bubble_sort(list)
      list.each_index do |i|
        (list.length - i - 1).times do |j|
          list[j], list[j + 1] = list[j + 1], list[j] if list[j] > list[j + 1]
          yield list, j
        end
      end
    end

    private

    def setup
      # Initialize Curses
      Curses.init_screen
      Curses.noecho
      Curses.nonl

      # Hide the cursor
      # Curses.curs_set(0)

      # Enable colored output
      Curses.start_color
      Curses.use_default_colors

      # Setup colors
      Curses.init_pair(Curses::COLOR_RED, Curses::COLOR_RED, -1)
    end

    def newline
      @cursor.incr_y
    end



    def run
      begin
        list = (1..20).to_a.shuffle
        tprint("Sortviz:  Visualized Sorting using Ruby and Curses. V 0.1.0")
        newline
        tprint("-----------------------------------------------------------")
        newline
        canvas = Curses::Window.new(@cursor.y + 20, Curses.cols - 50, @cursor.y, @cursor.x)
        color_pair = Curses.color_pair(Curses.const_get("COLOR_RED"))
        @cursor.switch_window canvas
        canvas.nodelay = 1
        @screen.refresh
        loop do
          bubble_sort2(list) do |new_list, selection|
            canvas.clear
            canvas.box('|', '--')
            @cursor.move(canvas.maxy - 2, 5)
            new_list.each_index do |i|
              tprint(("|%02d|" % new_list[i]), canvas)
              @cursor.decr_y
              canvas.attron(color_pair) if selection + 1  == i
              new_list[i].times do 
                tprint("|_ |", canvas)
                @cursor.decr_y
              end
              canvas.attroff(color_pair)
              @cursor.move_y(canvas.maxy - 2)
              @cursor.incr_x 5
            end
            Curses.doupdate
            sleep(1.02)
            return if canvas.getch == 'q'
          end
          canvas.close
          break if Curses.getch == 'q'
        end
      ensure
        Curses.close_screen
      end
    end

    def tprint(message, window = nil)
      window ||= @screen
      window.setpos(@cursor.y, @cursor.x)
      window.addstr(message)
    end
  end
end