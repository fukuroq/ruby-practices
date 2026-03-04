# frozen_string_literal: true

require 'optparse'

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('lwc')

  if 2 > ARGV.size
    file_name = ARGV[0]
    input_text = ARGV.empty? ? $stdin.read : File.read(file_name)
    outputSingleLine(file_name, input_text, options)
  else
    file_names = ARGV
    outputMultiLine(file_names, options)
  end
end

def outputSingleLine(file_name, text, options)
  # オプションがついていない場合
  if options.values.none?
    print format("% #{TAB_WIDTH}d", countLines(text)) +
      format("% #{TAB_WIDTH}d", countWords(text)) +
      format("% #{TAB_WIDTH}d", countBytes(text))
    puts ' ' + file_name if file_name
  end

  # オプションがついている場合
  print format("% #{TAB_WIDTH}d", countLines(text)) if options['l']
  print format("% #{TAB_WIDTH}d", countWords(text)) if options['w']
  print format("% #{TAB_WIDTH}d", countBytes(text)) if options['c']
  puts ' ' + file_name if !options.values.none? && file_name
end

def outputMultiLine(file_names, options)
  total_line_count, total_word_count, total_byte_count = 0, 0, 0
  file_names.each do |file_name|
    text = File.read(file_name)
    line_count = countLines(text)
    word_count = countWords(text)
    byte_count = countBytes(text)

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

def countLines(text)
  text.count("\n")
end

def countWords(text)
  text.split.count
end

def countBytes(text)
  text.bytesize
end

main
