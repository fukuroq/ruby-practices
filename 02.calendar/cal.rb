require 'optparse'
require "date"

# 日付を表示する部分の列数
NumberOfColumnsForDaySection = 7
# 日付を表示する部分の行数
NumberOfRowsForDaySection = 6

# コマンドライン引数を取得する
options = ARGV.getopts('y:m:')

today = Date.today
year = options["y"]&.to_i || today.year
month = options["m"]&.to_i || today.month
first_day_of_month = Date.new(year, month, 1)
last_day_of_month = Date.new(year, month, -1)

# 表示する全ての日付を持った配列を作成して、配列内の日付を2文字分の幅の文字列に変換する
day_section_texts = (1..last_day_of_month.day).to_a.map { |day| "%2d" % day }
# 現在の日付を表示する場合はコマンドラインの文字色と背景色を反転させる
if year == today.year && month == today.month
  day_section_texts.each_with_index do |day_section_text, i|
    day_section_texts[i] = "\e[7m#{day_section_texts[i]}\e[0m" if day_section_text == "%2d" % today.day
  end
end
# 日付の配列の先頭にスペースを挿入する
day_section_texts = Array.new(first_day_of_month.wday, "  ") + day_section_texts
# 日付の配列を日付を表示する部分の列数で区切る
day_section_texts = day_section_texts.each_slice(NumberOfColumnsForDaySection).to_a

# カレンダーを表示する
puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"
NumberOfRowsForDaySection.times { |i| puts day_section_texts[i]&.join(" ") || "\n" }
