# frozen_string_literal: true

require 'optparse'

MAX_NUMBER_OF_COLUMNS = 3
TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('a')
  file_names = Dir.glob('*', options['a'] ? File::FNM_DOTMATCH : 0)
  number_of_rows = file_names.length.ceildiv(MAX_NUMBER_OF_COLUMNS)
  column_width = calcurate_column_width(file_names)
  output_file_names(file_names, number_of_rows, column_width)
end

def calcurate_column_width(file_names)
  max_length_of_file_name = file_names.max_by(&:length).length
  TAB_WIDTH * (max_length_of_file_name / TAB_WIDTH + 1)
end

def output_file_names(file_names, number_of_rows, column_width)
  number_of_rows.times do |row|
    MAX_NUMBER_OF_COLUMNS.times do |column|
      print file_names[row + number_of_rows * column]&.ljust(column_width)
    end
    puts
  end
end

main
