# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')
  file_names = ARGV
  text_stats =
    if file_names.empty?
      [build_text_stat($stdin.read)]
    else
      file_names.map { build_text_stat(File.read(it), it) }
    end
  text_stats << build_text_stats_total(text_stats) if text_stats.size > 1
  columns = collect_show_count_columns(options)
  puts format_rows(text_stats, columns)
end

def build_text_stat(text, file_name = '')
  {
    line_count: text.count("\n"),
    word_count: text.split.count,
    byte_count: text.bytesize,
    file_name:
  }
end

def build_text_stats_total(text_stats)
  {
    line_count: text_stats.sum { it[:line_count] },
    word_count: text_stats.sum { it[:word_count] },
    byte_count: text_stats.sum { it[:byte_count] },
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

def format_rows(text_stats, columns)
  text_stats.map do |text_stat|
    counts_part = columns.map { format("% #{TAB_WIDTH}d", text_stat[it]) }.join
    file_name_part = text_stat[:file_name].empty? ? '' : " #{text_stat[:file_name]}"
    "#{counts_part}#{file_name_part}"
  end
end

main
