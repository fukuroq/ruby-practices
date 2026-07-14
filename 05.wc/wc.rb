# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc', symbolize_names: true)
  file_names = ARGV
  text_stats =
    if file_names.empty?
      [build_text_stat($stdin.read, options)]
    else
      file_names.map { build_text_stat(File.read(it), options, it) }
    end
  text_stats << build_total_text_stats(text_stats) if text_stats.size > 1
  puts format_rows(text_stats)
end

def build_text_stat(text, options, file_name = '')
  show_all = options.values.none?
  counts = {}
  counts[:line_count] = text.count("\n") if show_all || options[:l]
  counts[:word_count] = text.split.count if show_all || options[:w]
  counts[:byte_count] = text.bytesize if show_all || options[:c]
  {
    counts: counts,
    file_name:
  }
end

def build_total_text_stats(text_stats)
  total_counts = Hash.new(0)
  text_stats.each { it[:counts].each { |key, value| total_counts[key] += value } }
  {
    counts: total_counts,
    file_name: 'total'
  }
end

def format_rows(text_stats)
  text_stats.map do |text_stat|
    counts_part = text_stat[:counts].map { |_key, value| format("% #{TAB_WIDTH}d", value) }.join
    file_name_part = text_stat[:file_name].empty? ? '' : " #{text_stat[:file_name]}"
    "#{counts_part}#{file_name_part}"
  end
end

main
