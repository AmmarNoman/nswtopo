module GlyphLength
  WIDTHS = {
    ?A => 724, ?B => 598, ?C => 640, ?D => 750, ?E => 549, ?F => 484, ?G => 720, ?H => 742, ?I => 326, ?J => 315, ?K => 678, ?L => 522, ?M => 835,
    ?N => 699, ?O => 779, ?P => 532, ?Q => 779, ?R => 675, ?S => 536, ?T => 596, ?U => 722, ?V => 661, ?W => 975, ?X => 641, ?Y => 641, ?Z => 684,
    ?a => 441, ?b => 540, ?c => 448, ?d => 542, ?e => 466, ?f => 321, ?g => 479, ?h => 551, ?i => 278, ?j => 268, ?k => 530, ?l => 269, ?m => 833,
    ?n => 560, ?o => 554, ?p => 549, ?q => 534, ?r => 398, ?s => 397, ?t => 340, ?u => 542, ?v => 535, ?w => 818, ?x => 527, ?y => 535, ?z => 503,
    ?0 => 533, ?1 => 533, ?2 => 533, ?3 => 533, ?4 => 533, ?5 => 533, ?6 => 533, ?7 => 533, ?8 => 533, ?9 => 533, ?! => 254, ?" => 444, ?# => 644,
    ?$ => 536, ?% => 719, ?& => 796, ?' => 235, ?( => 304, ?) => 304, ?* => 416, ?+ => 533, ?, => 217, ?- => 294, ?. => 216, ?/ => 273, ?\\ => 273,
    ?[ => 342, ?] => 342, ?^ => 247, ?_ => 475, ?` => 247, ?: => 216, ?; => 217, ?< => 533, ?= => 533, ?> => 533, ?? => 361, ?@ => 757, ?\s => 200,
  }
  WIDTHS.default = WIDTHS[?M]
  
  def glyph_length(font_size, letter_spacing = 0, word_spacing = 0)
    WIDTHS.values_at(*chars).inject(0, &:+) * 0.001 * font_size + [ length - 1, 0 ].max * letter_spacing + count(?\s) * word_spacing
  end

  def in_two(font_size, letter_spacing, word_spacing)
    space_width = ?\s.glyph_length(font_size, letter_spacing, word_spacing)
    words, widths = split(match(?\n) ? ?\n : match(?/) ? ?/ : ?\s).map(&:strip).map do |word|
      [ word, word.glyph_length(font_size, letter_spacing, word_spacing) ]
    end.transpose
    (1...words.size).map do |index|
      [ 0...index, index...words.size ]
    end.map do |ranges|
      ranges.map do |range|
        [ words[range].join(?\s), widths[range].inject(&:+) + (range.size - 1) * space_width ]
      end.transpose
    end.min_by do |lines, line_widths|
      line_widths.max
    end || [ words, widths ]
  end
end

String.send :include, GlyphLength
