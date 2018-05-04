require 'pp'

class Shell
  def self.run(command)
    puts " --> #{command}"

    %x(#{command}).chomp
  end
end

class Window
  attr :id

  def initialize(id)
    @id = id
  end

  def self.by_click
    id = Shell.run("xdotool selectwindow").to_i

    Window.new(id)
  end

  def move(x, y)
    Shell.run("xdotool windowmove #{id} #{x} #{y}")
      .split(' ')
      .map(&:to_i)
  end

  def resize(w, h)
    Shell.run("xdotool windowsize #{id} #{w} #{h}")
      .split(' ')
      .map(&:to_i)
  end

  def geometry
    _id, position, geometry = Shell.run("xdotool getwindowgeometry #{id}").split("\n")

    x, y = position.scan(/(\d+),(\d+)/).first.map(&:to_i)
    w, h = geometry.scan(/(\d+)x(\d+)/).first.map(&:to_i)

    { x: x, y: y, w: w, h: h }
  end
end

class Split
  attr :windows, :top_left, :bounding_box, :spacing

  def initialize(windows, top_left, bounding_box, spacing)
    @windows = windows
    @top_left = top_left
    @bounding_box = bounding_box
    @spacing = spacing
  end

  def perform
    (1..3).each do # doing this repeatedly fixes some issues with glued windows
      windows.each_with_index do |window, index|
        place_window(window, spacing, top_left, bounding_box, index, windows.size)
      end
    end
  end

  private
  def spaced_size(total_length, spacing, num_windows)
    (total_length - (num_windows - 1) * spacing) / num_windows
  end

  def spaced_position(total_length, spacing, num_windows, index)
    index * (spacing + spaced_size(total_length, spacing, num_windows))
  end
end

class SplitH < Split
  private
  def place_window(window, spacing, top_left, bounding_box, index, num_windows)
    x = top_left[0] + spaced_position(bounding_box[0], spacing, num_windows, index)
    y = top_left[1]
    window.move(x, y)

    w = spaced_size(bounding_box[0], spacing, num_windows)
    h = bounding_box[1]
    window.resize(w, h)
  end
end

class SplitV < Split
  private
  def place_window(window, spacing, top_left, bounding_box, index, num_windows)
    x = top_left[0]
    y = top_left[1] + spaced_position(bounding_box[1], spacing, num_windows, index)
    window.move(x, y)

    w = bounding_box[0]
    h = spaced_size(bounding_box[1], spacing, num_windows)
    window.resize(w, h)
  end
end

class Display
  def self.size
    Shell.run("xdotool getdisplaygeometry")
      .split(' ')
      .map(&:to_i)
  end
end
