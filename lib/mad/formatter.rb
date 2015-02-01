require 'rouge'

module Mad
  class Formatter < Rouge::Formatter
    attr_reader :toks

    def initialize(*)
      @toks ||= []
    end

    def stream(tokens, &b)
      fp = File.open('tokenizer.txt', 'w') if ENV['DEBUG'] == "1"
      line = []
      tokens.each do |tok, val|
        fp.puts "parsing #{tok.inspect} - #{val.inspect}" if ENV['DEBUG'] == "1"
        if val.include?("\n") && val.gsub(/\n/, '') == ""
          val.count("\n").times do
            @toks << line
            line = []
          end
        elsif val.include? "\n"
          val.split("\n").each do |x|
            if x == ""
              @toks << line
              line = []
            else
              x.length.times do
                line << normalize_qualname(tok.qualname)
              end
            end
          end
        else
          val.length.times do
            line << normalize_qualname(tok.qualname)
          end
        end
        fp.puts "tokens: #{line} #{@toks.length}:#{line.length}" if ENV['DEBUG'] == "1"
        yield ""
      end

      @toks << line
      fp.close if ENV['DEBUG'] == "1"
    end

    private

    def normalize_qualname(qn)
      qn.downcase.gsub(/\./, '_').to_sym
    end
  end
end
