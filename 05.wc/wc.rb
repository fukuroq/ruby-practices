# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')
  show_all = options.values.none?
  file_name = ARGV[0]
  file_text = File.read(file_name)
  result = []
  result << format("% #{TAB_WIDTH}d", file_text.count("\n")) if show_all || options['l']
  result << format("% #{TAB_WIDTH}d", file_text.split.count) if show_all || options['w']
  result << format("% #{TAB_WIDTH}d", file_text.bytesize) if show_all || options['c']
  result << " #{file_name}"
  puts result.join
end

main
