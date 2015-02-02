module Mad
  class ThemeKeywordUnknown < Exception; end

  # Basic theme suppot, colouring tokens and the like.
  class Theme
    BLUE    = Termbox::TB_BLUE
    RED     = Termbox::TB_RED
    GREEN   = Termbox::TB_GREEN
    WHITE   = Termbox::TB_WHITE
    MAGENTA = Termbox::TB_MAGENTA
    BLACK   = Termbox::TB_BLACK
    YELLOW  = Termbox::TB_YELLOW
    CYAN    = Termbox::TB_CYAN

    DEFAULT_THEME = {
      keyword:                  BLUE,
      keyword_type:             BLUE,
      name:                     CYAN,
      name_builtin:             YELLOW,
      name_constant:            RED,
      name_function:            YELLOW,
      name_variable_instance:   BLACK,
      name_variable_global:     BLACK,
      name_builtin_pseudo:      BLACK,
      name_variable:            GREEN,
      name_class:               GREEN,
      name_other:               GREEN,
      name_tag:                 GREEN,
      operator:                 CYAN,
      operator_word:            CYAN,
      punctuation:              CYAN,
      punctuation_indicator:    CYAN,
      name_namespace:           CYAN,
      keyword_pseudo:           CYAN,

      literal_string:           RED,
      literal_string_backtick:  RED,
      literal_string_symbol:    RED,
      literal_string_double:    RED,
      literal_string_single:    RED,
      literal_number:           RED,
      literal_number_hex:       RED,
      literal_number_integer:   RED,
      literal_string_interpol:  RED,
      literal_string_regex:     RED,
      literal_string_escape:    RED,

      comment_single:           RED,
      comment:                  RED,
      comment_preproc:          GREEN,
      error:                    CYAN,
      text:                     CYAN
    }

    def self.get_colour(kind)
      colour = DEFAULT_THEME[kind]
      fail(ThemeKeywordUnknown, kind) if colour.nil? && !kind.nil?

      colour || CYAN
    end
  end
end
