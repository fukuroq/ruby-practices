# frozen_string_literal: true

TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  file_name = ARGV[0]
  file_text = File.read(file_name)
  result = []
  result << format("% #{TAB_WIDTH}d", file_text.count("\n"))
  result << format("% #{TAB_WIDTH}d", file_text.split.count)
  result << format("% #{TAB_WIDTH}d", file_text.bytesize)
  result << " #{file_name}"
  puts result.join
end

main
