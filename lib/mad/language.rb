require 'rouge'
module Mad
  module Language
    class << self
      def get_available_lexers
        ObjectSpace.each_object(Rouge::Lexers.singleton_class)
      end
    end
  end
end
