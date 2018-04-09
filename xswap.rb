#!/home/sraez/.rvm/rubies/ruby-2.5.1/bin/ruby

require_relative 'lib'

class Program
  def run
    targets = 2

    one, two = (0..1).map do |n|
      puts "Need #{targets-n} more windows"

      Window.by_click
    end

    one_geometry, two_geometry = [one, two].map(&:geometry)

    apply(two, one_geometry)
    apply(one, two_geometry)
  end

  def apply(window, geometry)
    window.move(geometry[:x], geometry[:y])
    window.resize(geometry[:w], geometry[:h])
  end
end

Program.new.run
