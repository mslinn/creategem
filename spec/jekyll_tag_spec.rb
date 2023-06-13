require_relative '../lib/creategem/cli/cli_jekyll'

class JekyllTagTest
  RSpec.describe ::Creategem::Cli do
    it 'tests tag option combinations' do
      params = [
        %w[option1 string],
        %w[option2 boolean],
        %w[option3 numeric]
      ]
      expect(params.combination(0).to_a).to eq [[]]
      expect(params.combination(1).to_a).to eq [
        [%w[option1 string]],
        [%w[option2 boolean]],
        [%w[option3 numeric]]
      ]
      expect(params.combination(2).to_a).to eq [
        [%w[option1 string],  %w[option2 boolean]],
        [%w[option1 string],  %w[option3 numeric]],
        [%w[option2 boolean], %w[option3 numeric]]
      ]
      expect(params.combination(3).to_a).to eq [
        [%w[option1 string], %w[option2 boolean], %w[option3 numeric]]
      ]

      actual = described_class.combinations params
      expected = [
        [[]],
        ["option1='somevalue'", 'option2', 'option3=1234'],
        ["option1='somevalue'", 'option2'],
        ["option1='somevalue'", 'option3=1234'],
        ['option2', 'option3=1234'],
        ["option1='somevalue'"],
        ['option2'],
        ['option3=1234'],
      ]
      expect(actual).to eq(expected)
    end
  end
end
