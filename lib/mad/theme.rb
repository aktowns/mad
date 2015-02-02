module Mad
  class ThemeKeywordUnknown < Exception; end

  module Default
    BLUE    = Termbox::TB_BLUE
    RED     = Termbox::TB_RED
    GREEN   = Termbox::TB_GREEN
    WHITE   = Termbox::TB_WHITE
    MAGENTA = Termbox::TB_MAGENTA
    BLACK   = Termbox::TB_BLACK
    YELLOW  = Termbox::TB_YELLOW
    CYAN    = Termbox::TB_CYAN
  end

  # Base16 default colourset
  module Base16
    BASE00 = 0xea
    BASE01 = 0xeb
    BASE02 = 0xed
    BASE03 = 0xf6
    BASE04 = 0xf9
    BASE05 = 0xfb
    BASE06 = 0xfe
    BASE07 = 0xe7
    BASE08 = 0xa7
    BASE09 = 0xad
    BASE0A = 0xde
    BASE0B = 0x8f
    BASE0C = 0x6d
    BASE0D = 0x6d
    BASE0E = 0x8b
    BASE0F = 0x83
  end

  # Basic theme suppot, colouring tokens and the like.
  class Theme
    include Base16

    DEFAULT_THEME = {
      keyword:                  BASE0E,
      keyword_type:             BASE0E,
      keyword_pseudo:           BASE0E,
      keyword_declaration:      BASE0E,
      keyword_constant:         BASE0E,
      keyword_reserved:         BASE0E,
      name:                     BASE05,
      name_decorator:           BASE0A,
      name_builtin:             BASE0D,
      name_constant:            BASE09,
      name_exception:           BASE06,
      name_function:            BASE0D,
      name_variable_instance:   BASE08,
      name_namespace:           BASE0A,
      name_attribute:           BASE0D,
      name_variable_global:     BASE08,
      name_builtin_pseudo:      BASE0A,
      name_variable:            BASE0A,
      name_class:               BASE0A,
      name_other:               BASE0A,
      name_tag:                 BASE0A,
      operator:                 BASE05,
      operator_word:            BASE05,
      punctuation:              BASE05,
      punctuation_indicator:    BASE05,

      literal_string:           BASE0B,
      literal_string_backtick:  BASE0B,
      literal_string_symbol:    BASE0B,
      literal_string_double:    BASE0B,
      literal_string_single:    BASE0B,
      literal_number:           BASE0B,
      literal_number_hex:       BASE0B,
      literal_number_integer:   BASE0B,
      literal_number_float:     BASE0B,
      literal_string_interpol:  BASE0F,
      literal_string_regex:     BASE0C,
      literal_string_escape:    BASE0F,

      comment_single:           BASE03,
      comment_multiline:        BASE03,
      comment:                  BASE03,
      comment_preproc:          BASE0A,
      comment_doc:              BASE04,
      error:                    BASE07,
      other:                    BASE06,
      text:                     BASE06,

      linum:                    BASE05,
      linum_background:         BASE00
    }

    def self.get_colour(kind)
      colour = DEFAULT_THEME[kind]
      fail(ThemeKeywordUnknown, kind) if colour.nil? && !kind.nil?

      colour || BASE06
    end
  end
end
