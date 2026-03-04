# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')

  if ARGV.size <= 1
    file_name = ARGV[0]
    input_text = ARGV.empty? ? $stdin.read : File.read(file_name)
    output_single_line(file_name, input_text, options)
  else
    file_names = ARGV
    output_multi_line(file_names, options)
  end
end

def output_single_line(file_name, text, options)
  # オプションがついていない場合
  if options.values.none?
    print format("% #{TAB_WIDTH}d", count_lines(text)) +
      format("% #{TAB_WIDTH}d", count_words(text)) +
      format("% #{TAB_WIDTH}d", count_bytes(text))
    puts ' ' + file_name if file_name
  end

  # オプションがついている場合
  print format("% #{TAB_WIDTH}d", count_lines(text)) if options['l']
  print format("% #{TAB_WIDTH}d", count_words(text)) if options['w']
  print format("% #{TAB_WIDTH}d", count_bytes(text)) if options['c']
  puts ' ' + file_name if !options.values.none? && file_name
end

def output_multi_line(file_names, options)
  total_line_count, total_word_count, total_byte_count = 0, 0, 0
  file_names.each do |file_name|
    text = File.read(file_name)
    line_count = count_lines(text)
    word_count = count_words(text)
    byte_count = count_bytes(text)

    # オプションがついていない場合
    puts format("% #{TAB_WIDTH}d", line_count) +
      format("% #{TAB_WIDTH}d", word_count) +
      format("% #{TAB_WIDTH}d", byte_count) +
    ' ' + file_name if options.values.none?

    # オプションがついている場合
    print format("% #{TAB_WIDTH}d", line_count) if options['l']
    print format("% #{TAB_WIDTH}d", word_count) if options['w']
    print format("% #{TAB_WIDTH}d", byte_count) if options['c']
    puts ' ' + file_name if !options.values.none?

    total_line_count += line_count
    total_word_count += word_count
    total_byte_count += byte_count
  end

  # オプションがついていない場合
  puts format("% #{TAB_WIDTH}d", total_line_count) +
    format("% #{TAB_WIDTH}d", total_word_count) +
    format("% #{TAB_WIDTH}d", total_byte_count) +
    ' ' + 'total' if options.values.none?

  # オプションがついている場合
  print format("% #{TAB_WIDTH}d", total_line_count) if options['l']
  print format("% #{TAB_WIDTH}d", total_word_count) if options['w']
  print format("% #{TAB_WIDTH}d", total_byte_count) if options['c']
  puts ' ' + 'total' if !options.values.none?
end

def count_lines(text)
  text.count("\n")
end

def count_words(text)
  text.split.count
end

def count_bytes(text)
  text.bytesize
end

main
