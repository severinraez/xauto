#!/home/sraez/.rvm/rubies/ruby-2.5.1/bin/ruby

require_relative 'lib'

class Program
  def run
    panes = 3

    windows = (0..2).map do |n|
      puts "Need #{panes-n} more windows"

      Window.by_click
    end

    SplitH.new(windows, [0,0], Display.size).perform
  end
end

Program.new.run
