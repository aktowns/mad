class ThemeKeywordUnknown < Exception; end
class Theme
  BLUE    = Termbox::TB_BLUE
  RED     = Termbox::TB_RED
  GREEN   = Termbox::TB_GREEN
  WHITE   = Termbox::TB_WHITE
  MAGENTA = Termbox::TB_MAGENTA
  BLACK   = Termbox::TB_BLACK
  YELLOW  = Termbox::TB_YELLOW
  CYAN    = Termbox::TB_CYAN

  def self.get_colour(kind)
    case kind
    when :keyword                 then BLUE         # ie class
    when :name                    then CYAN
    when :name_builtin            then YELLOW       # ie require
    when :name_constant           then RED          # ie class blah < *<NAME>*
    when :name_function           then YELLOW       # ie def *<NAME>*
    when :name_variable_instance  then BLACK        # ie @blah
    when :name_variable_global    then BLACK
    when :name_class              then GREEN        # ie class *<NAME>*
    when :operator                then CYAN
    when :punctuation             then CYAN
    when :name_namespace          then CYAN
    when :keyword_pseudo          then CYAN

    when :literal_string_backtick then RED
    when :literal_string_symbol   then RED
    when :literal_string_double   then RED
    when :literal_string_single   then RED
    when :literal_number_hex      then RED
    when :literal_number_integer  then RED
    when :literal_string_interpol then RED
    when :literal_string_regex    then RED

    when :comment_single          then RED
    when :error                   then CYAN
    when :text                    then CYAN
    else
      raise ThemeKeywordUnknown.new(kind) unless kind.nil?
      Termbox::TB_CYAN
    end
  end
end
