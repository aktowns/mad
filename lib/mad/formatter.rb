require 'rouge'
require 'mad/log'

module Mad
  # A rouge formatter that exports the token stream
  class Formatter < Rouge::Formatter
    attr_reader :toks

    def initialize(*)
      @toks ||= []
    end

    def stream(tokens, &_b)
      line = []
      tokens.each do |tok, val|
        if val.include?("\n") && val.gsub(/\n/, '') == ''
          val.count("\n").times do
            @toks << line
            line = []
          end
        elsif val.include? "\n"
          val.split("\n").each do |x|
            if x == ''
              @toks << line
              line = []
            else
              x.length.times { line << normalize_qualname(tok.qualname) }
            end
          end
        else
          val.length.times do
            line << normalize_qualname(tok.qualname)
          end
        end
        yield ''
      end

      @toks << line
    end

    private

    def normalize_qualname(qn)
      qn.downcase.gsub(/\./, '_').to_sym
    end
  end
end
