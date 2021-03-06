#!/home/sraez/.rvm/rubies/ruby-2.5.1/bin/ruby

require_relative 'lib'

class Program
  def run
    slices = 2

    target, other = (0..1).map do |n|
      puts "Need #{slices-n} more windows"

      window = Window.by_click

      if window.nil?
        puts "Desktop clicked, aborting"
        exit
      end

      window
    end

    bounding_box = target.geometry
    SplitH.new(
      [target, other],
      [bounding_box[:x], bounding_box[:y]],
      [bounding_box[:w], bounding_box[:h]],
      20
    ).perform
  end
end

Program.new.run
