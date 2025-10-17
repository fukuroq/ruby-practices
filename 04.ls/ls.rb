# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_NUMBER_OF_COLUMNS = 3
TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数
OWNER_DIGIT = 3
GROUP_DIGIT = 4
OTHER_DIGIT = 5
SET_USER_ID_DIGIT = 2
SET_GROUP_ID_DIGIT = 5
STICKY_BIT_DIGIT = 8
HARD_LINK_FORWARD_WIDTH = 2
BYTESIZE_FORWARD_WIDTH = 1
LONG_FORMAT_SIDE_WIDTH = 2

FILE_TYPES = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  options = ARGV.getopts('arl')
  file_names = Dir.glob('*', options['a'] ? File::FNM_DOTMATCH : 0)
  sorted_file_names = options['r'] ? file_names.reverse : file_names
  if options['l']
    long_format_file_names = generate_long_format(sorted_file_names)
    total_block_size = long_format_file_names.sum { |long_format_file_name| long_format_file_name[:block_size] }
    long_format_widths = create_long_format_widths(long_format_file_names)
    output_long_format(long_format_file_names, total_block_size, long_format_widths)
  else
    number_of_rows = sorted_file_names.length.ceildiv(MAX_NUMBER_OF_COLUMNS)
    column_width = calcurate_column_width(sorted_file_names)
    output_file_names(sorted_file_names, number_of_rows, column_width)
  end
end

def generate_long_format(file_names)
  file_names.map do |file_name|
    file_status = File::Stat.new(file_name)
    {
      block_size: file_status.blocks,
      file_type: FILE_TYPES[file_status.ftype],
      permission: generate_permission(file_status),
      hard_link: file_status.nlink,
      owner_name: Etc.getpwuid(file_status.uid).name,
      group_name: Etc.getgrgid(file_status.gid).name,
      bytesize: file_status.size,
      timestamp: generate_timestamp(file_status),
      file_name:
    }
  end
end

def generate_permission(file_status)
  file_mode = format('%06o', file_status.mode)
  permission = ''
  [OWNER_DIGIT, GROUP_DIGIT, OTHER_DIGIT].each do |digit|
    permission += PERMISSIONS[file_mode[digit]]
  end
  convert_permission(permission, file_status)
end

def convert_permission(permission, file_status)
  if file_status.setuid?
    permission[SET_USER_ID_DIGIT] = permission[SET_USER_ID_DIGIT] == 'x' ? 's' : 'S'
  elsif file_status.setgid?
    permission[SET_GROUP_ID_DIGIT] = permission[SET_GROUP_ID_DIGIT] == 'x' ? 's' : 'S'
  elsif file_status.sticky?
    permission[STICKY_BIT_DIGIT] = permission[STICKY_BIT_DIGIT] == 'x' ? 't' : 'T'
  end
  permission
end

def generate_timestamp(file_status)
  modify_time = file_status.mtime
  Time.now.year > modify_time.year ? modify_time.strftime('%_m %_d %_5Y') : modify_time.strftime('%_m %_d %H:%M')
end

def create_long_format_widths(long_format_file_names)
  long_format_widths = {}
  %i[hard_link owner_name group_name bytesize timestamp].each do |long_format_key|
    long_format_widths[long_format_key] = long_format_file_names.map { |long_format_file_name| long_format_file_name[long_format_key] }.max.to_s.length
  end
  long_format_widths[:hard_link] += HARD_LINK_FORWARD_WIDTH
  long_format_widths[:bytesize] += BYTESIZE_FORWARD_WIDTH
  long_format_widths
end

def output_long_format(long_format_file_names, total_block_size, long_format_widths)
  puts "total: #{total_block_size}"
  long_format_file_names.each do |long_format_file_name|
    long_format_file_name.reject { |key| key == :block_size }.each do |key, value|
      if %i[hard_link bytesize].include?(key)
        print value.to_s.rjust(long_format_widths[key])
      elsif %i[owner_name group_name].include?(key)
        print value.to_s.ljust(long_format_widths[key]).center(long_format_widths[key] + LONG_FORMAT_SIDE_WIDTH)
      elsif key == :timestamp
        print value.to_s.center(long_format_widths[key] + LONG_FORMAT_SIDE_WIDTH)
      else
        print value
      end
    end
  end
  puts
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
