#!/home/sraez/.rvm/rubies/ruby-2.5.1/bin/ruby

require_relative 'lib'

class Program
  def run
    panes = 3

    windows = (0..2).map do |n|
      puts "Need #{panes-n} more windows"

      Window.by_click

      if window.nil?
        puts "Desktop clicked, aborting"
        exit
      end

      window
    end

    padding = 50
    size = Display.size.map{ |d| d-padding }
    SplitH.new(windows, [padding,padding], size, padding).perform
  end
end

Program.new.run
