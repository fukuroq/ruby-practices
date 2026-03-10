# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')
  file_names = ARGV
  file_statistics = build_file_statistics(file_names)
  if file_statistics.size > 1
    file_statistics << {
      line_count: file_statistics.sum { it[:line_count] },
      word_count: file_statistics.sum { it[:word_count] },
      byte_count: file_statistics.sum { it[:byte_count] },
      file_name: 'total'
    }
  end
  formated_rows = format_rows(file_statistics, options)
  puts formated_rows.join("\n")
end

def build_file_statistics(file_names)
  file_names.map do |file_name|
    file_text = File.read(file_name)
    {
      line_count: file_text.count("\n"),
      word_count: file_text.split.count,
      byte_count: file_text.bytesize,
      file_name: file_name
    }
  end
end

def format_rows(file_statistics, options)
  show_all = options.values.none?
  file_statistics.map do |file_statistic|
    result = []
    result << format("% #{TAB_WIDTH}d", file_statistic[:line_count]) if show_all || options['l']
    result << format("% #{TAB_WIDTH}d", file_statistic[:word_count]) if show_all || options['w']
    result << format("% #{TAB_WIDTH}d", file_statistic[:byte_count]) if show_all || options['c']
    result << " #{file_statistic[:file_name]}"
    result.join
  end
end

main
