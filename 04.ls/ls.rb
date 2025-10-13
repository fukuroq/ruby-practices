# frozen_string_literal: true

require 'optparse'

MAX_NUMBER_OF_COLUMNS = 3
TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  options = ARGV.getopts('arl')
  file_names = Dir.glob('*', options['a'] ? File::FNM_DOTMATCH : 0)
  sorted_file_names = options['r'] ? file_names.reverse : file_names
  if options['l']
    long_format_file_names = generate_long_format(sorted_file_names)
    total_block_size = long_format_file_names.inject(0) { |sum, hash| sum + hash[:block_size] }
    output_long_format(long_format_file_names, total_block_size)
  else
    number_of_rows = sorted_file_names.length.ceildiv(MAX_NUMBER_OF_COLUMNS)
    column_width = calcurate_column_width(sorted_file_names)
    output_file_names(sorted_file_names, number_of_rows, column_width)
  end
end

def generate_long_format(file_names)
  long_format_file_names = []
  file_names.each do |file_name|
    file_status = File::Stat.new(file_name)
    long_format_file_names << {
      block_size: file_status.blocks
    }
  end
  long_format_file_names
end

def output_long_format(long_format_file_names, total_block_size)
  puts "total: #{total_block_size}"
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
