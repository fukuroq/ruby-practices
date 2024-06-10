# frozen_string_literal: true

MAX_NUMBER_OF_COLUMNS = 3
TAB_WIDTH = 8 # ターミナルのデフォルトのタブの文字数

def main
  file_names = Dir.glob('*')
  number_of_rows = file_names.length.ceildiv(MAX_NUMBER_OF_COLUMNS)
  column_width = calcurate_column_width(file_names)
  output_file_names(file_names, number_of_rows, column_width)
end

def calcurate_column_width(file_names)
  max_length_of_file_name = file_names.max_by(&:length).length
  # FreeBSD版lsコマンドで列の幅を求める際に行われている下記のビット演算を参考に実装。
  # colwidth = (colwidth + tabwidth) & ~(tabwidth - 1)
  # 例: ファイル名の最大長が17、タブの文字数が8の場合、25(0001 1001)と7を論理反転した値(1111 1000)の論理積である24(0011 1000)が求まる。
  (max_length_of_file_name + TAB_WIDTH) & ~(TAB_WIDTH - 1)
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
