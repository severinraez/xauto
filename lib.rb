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
  attr :windows, :top_left, :bounding_box

  def initialize(windows, top_left, bounding_box)
    @windows = windows
    @top_left = top_left
    @bounding_box = bounding_box
  end
end

class SplitH < Split
  def perform
    padding = 100

    windows.each_with_index do |window, index|
      place_window(window, padding, top_left, bounding_box, index, windows.size)
    end
  end

  private
  def place_window(window, padding, top_left, bounding_box, index, num_windows)
    x = padding + index * ((bounding_box[0] - padding*2)/num_windows)
    y = padding
    window.move(x, y)

    w = (bounding_box[0] - padding * 2 - (num_windows - 1) * padding) / num_windows
    h = bounding_box[1] - padding * 2
    window.resize(w, h)
  end
end

class SplitV < Split
  def perform
    padding = 10

    puts bounding_box
    windows.each_with_index do |window, index|
      place_window(window, padding, top_left, bounding_box, index, windows.size)
    end
  end

  private
  def place_window(window, padding, top_left, bounding_box, index, num_windows)
    x = top_left[0]
    y = top_left[1] + (bounding_box[1] / num_windows) * index
    pp tl: top_left, bb: bounding_box, i: index, n: num_windows
    window.move(x, y)

    w = bounding_box[0]
    h = (bounding_box[1] / num_windows) - padding
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
