# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')
  file_names = ARGV
  if file_names.empty?
    file_statistics = [build_file_statistic($stdin.read)]
  else
    file_statistics = file_names.map { build_file_statistic(File.read(it), it) }
  end
  file_statistics << build_file_statistics_total(file_statistics) if file_statistics.size > 1
  columns = collect_display_columns(options)
  output_file_statistics(file_statistics, columns)
end

def build_file_statistic(text, file_name = '')
  {
    line_count: text.count("\n"),
    word_count: text.split.count,
    byte_count: text.bytesize,
    file_name:
  }
end

def build_file_statistics_total(file_statistics)
  {
    line_count: file_statistics.sum { it[:line_count] },
    word_count: file_statistics.sum { it[:word_count] },
    byte_count: file_statistics.sum { it[:byte_count] },
    file_name: 'total'
  }
end

def collect_display_columns(options)
  show_all = options.values.none?
  columns = []
  columns << :line_count if show_all || options['l']
  columns << :word_count if show_all || options['w']
  columns << :byte_count if show_all || options['c']
  columns
end

def output_file_statistics(file_statistics, columns)
  puts file_statistics.map { format_row(it, columns) }.join("\n")
end

def format_row(file_statistic, columns)
  formatted_counts = columns.map { format("% #{TAB_WIDTH}d", file_statistic[it]) }.join
  "#{formatted_counts} #{file_statistic[:file_name]}"
end

main
