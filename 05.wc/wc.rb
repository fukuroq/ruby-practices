# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')
  file_names = ARGV
  text_statistics =
    if file_names.empty?
      [build_text_statistic($stdin.read)]
    else
      file_names.map { build_text_statistic(File.read(it), it) }
    end
  text_statistics << build_text_statistics_total(text_statistics) if text_statistics.size > 1
  columns = collect_show_count_columns(options)
  puts text_statistics.map { format_row(it, columns) }
end

def build_text_statistic(text, file_name = '')
  {
    line_count: text.count("\n"),
    word_count: text.split.count,
    byte_count: text.bytesize,
    file_name:
  }
end

def build_text_statistics_total(text_statistics)
  {
    line_count: text_statistics.sum { it[:line_count] },
    word_count: text_statistics.sum { it[:word_count] },
    byte_count: text_statistics.sum { it[:byte_count] },
    file_name: 'total'
  }
end

def collect_show_count_columns(options)
  show_all = options.values.none?
  columns = []
  columns << :line_count if show_all || options['l']
  columns << :word_count if show_all || options['w']
  columns << :byte_count if show_all || options['c']
  columns
end

def format_row(text_statistic, columns)
  counts_part = columns.map { format("% #{TAB_WIDTH}d", text_statistic[it]) }.join
  file_name_part = text_statistic[:file_name].empty? ? '' : " #{text_statistic[:file_name]}"
  "#{counts_part}#{file_name_part}"
end

main
