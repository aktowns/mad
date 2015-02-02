require 'rouge'
require 'mad/log'

module Mad
  # Basic language handling
  module Language
    class << self
      def available_lexers
        lexers = ObjectSpace.each_object(Rouge::Lexer.singleton_class).map do |klass|
          klass_name = klass.name

          # We only want top level classes
          if klass_name.count(':') == 4
            normalised_name = normalize_name(klass_name.split('::')[-1])

            [normalised_name, klass]
          end
        end.compact.flatten

        Hash[*lexers]
      end

      def infer_language(file)
        Rouge::Lexer.guess_by_filename(file)
      end

      private

      def normalize_name(name)
        name.downcase.to_sym
      end
    end
  end
end
