require_relative '../lib/creategem/cli/cli_jekyll'

class JekyllTagTest
  RSpec.describe ::Creategem::Cli do
    it 'tests tag option combinations' do
      params = [
        %w[option1 string],
        %w[option2 boolean],
        %w[option3 numeric]
      ]
      actual = described_class.combinations(params)
      expected = [
        '',
        'option1',
        'option2',
        'option3',
        'option1 option2',
        'option1 option3',
        'option2 option3',
        'option1 option2 option3'
      ]
      expect(actual).to eq(expected)
    end
  end
end
