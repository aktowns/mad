require 'spec_helper'
require 'tempfile'

# A crazy text editor written in ruby.
module Mad
  describe Language do
    it 'gives me a list of lexers' do
      expect(Language.available_lexers).to include(:ruby)
      expect(Language.available_lexers.length).to be > 0
    end

    it 'can infer a language from a file' do
      file = Tempfile.new(['hello', '.rb'])
      file.puts 'puts "hello world"'
      file.close
      expect(Language.infer_language(file.path)).to eq(:ruby)

      file.unlink
    end
  end
end
