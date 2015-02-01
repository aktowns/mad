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
      name:                     CYAN,
      name_builtin:             YELLOW,
      name_constant:            RED,
      name_function:            YELLOW,
      name_variable_instance:   BLACK,
      name_variable_global:     BLACK,
      name_class:               GREEN,
      operator:                 CYAN,
      punctuation:              CYAN,
      name_namespace:           CYAN,
      keyword_pseudo:           CYAN,

      literal_string_backtick:  RED,
      literal_string_symbol:    RED,
      literal_string_double:    RED,
      literal_string_single:    RED,
      literal_number_hex:       RED,
      literal_number_integer:   RED,
      literal_string_interpol:  RED,
      literal_string_regex:     RED,

      comment_single:           RED,
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
