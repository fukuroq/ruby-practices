#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.map do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, i|
  break if i > 9 # 10フレーム分(iが0~9)の計算を終えたら処理を終える

  point +=
    if frame[0] == 10 # ストライク
      if frames[i + 1][0] == 10 # 次の投球もストライクだった場合
        frame[0] + frames[i + 1][0] + frames[i + 2][0]
      else
        frame[0] + frames[i + 1].sum
      end
    elsif frame.sum == 10 # スペア
      frame.sum + frames[i + 1][0]
    else
      frame.sum
    end
end
puts point
