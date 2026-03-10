# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')
  show_all = options.values.none?
  file_names = ARGV
  line_count_total, word_count_total, byte_count_total = 0, 0, 0
  file_names.map do |file_name|
    file_text = File.read(file_name)
    result = []
    line_count = file_text.count("\n")
    line_count_total += line_count
    word_count = file_text.split.count
    word_count_total += word_count
    byte_count = file_text.bytesize
    byte_count_total += byte_count
    result << format("% #{TAB_WIDTH}d", line_count) if show_all || options['l']
    result << format("% #{TAB_WIDTH}d", word_count) if show_all || options['w']
    result << format("% #{TAB_WIDTH}d", byte_count) if show_all || options['c']
    result << " #{file_name}"
    puts result.join
  end
  if file_names.size > 1
    result = []
    result << format("% #{TAB_WIDTH}d", line_count_total) if show_all || options['l']
    result << format("% #{TAB_WIDTH}d", word_count_total) if show_all || options['w']
    result << format("% #{TAB_WIDTH}d", byte_count_total) if show_all || options['c']
    result << " total"
    puts result.join
  end
end

main
