require 'rouge'
require 'linguist'

module Mad
  module Language
    class << self
      def available_lexers
        lexers = ObjectSpace.each_object(Rouge::Lexer.singleton_class).map do |klass|
          klass_name = klass.name

          # We only want top level classes
          if klass_name.count(':') == 4
            normalised_name = klass_name.split('::')[-1].downcase.to_sym

            [normalised_name, klass]
          end
        end.compact.flatten

        Hash[*lexers]
      end

      def infer_language(file)
        lang = Linguist::FileBlob.new(file).language
        return :unknown if lang.nil?

        lang.ace_mode.downcase.to_sym
      end
    end
  end
end
