# frozen_string_literal: true

RSpec.describe Hash do
  context 'trie' do
    let(:trie) do
      YAML.safe_load <<~YML
        a:
          name: a
          b:
            name: b
            c:
              name: c
              d:
                name: d
                e:
                  name: e
      YML
    end

    it 'has a dig replacement' do
      expect({ a: { b: { c: { d: 2 } } } }.dig(:a, :b, :c, :d)).to eq(2)
    end

    it 'can clone values from one branch to other appending suffixes' do
      trie.clone_values from_keys: %w[a b],
                        to_keys: %w[a test],
                        suffix: '-test'

      expect(trie['a']['test']['c']['name']).to eq('c-test')
      expect(trie['a']['test']['c']['d']['name']).to eq('d-test')
      expect(trie['a']['test']['c']['d']['e']['name']).to eq('e-test')
    end

    it 'can deep dup' do
      trie.deep_dup['a']['b'][:ddup] = 'lol'
      expect(trie['a']['b'][:ddup]).to be_nil
    end
  end
end
