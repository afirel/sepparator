require 'spec_helper'

describe Sepparator::SchemaDetector do
  let(:hash) {
    {
      integer: 1,
      float: 0.1,
      string: 'foobar',
      date: Date.today,
      timestamp: DateTime.now
    }
  }

  let(:expected_schema) {
    Hash[hash.keys.zip(hash.values.map { |v| v.class })]
  }

  context '#for_hash' do
    it 'detects a schema given a hash' do
      schema = subject.for_hash(hash)
      expect(schema).to eq(expected_schema)
    end
    it 'ignores nil values' do
      schema = subject.for_hash(hash.merge({nilvalue: nil}))
      expect(schema[:nilvalue]).to be_nil
    end
  end

  context '#for_array' do
    it 'detects a schema given an array of hashes' do
      input = 10.times.map { |_| hash }
      schema = subject.for_array(input)
      expect(schema).to eq(expected_schema)
    end
    it 'detects Object type when different types present' do
      differing_type_hash = hash.merge({integer: 'not-an-int'})
      input = 10.times.map { |_| hash } + [differing_type_hash]
      schema = subject.for_array(input)
      expect(schema[:integer]).to eq(Object)
    end
    it 'raises when different key entries are given' do
      different_keys = hash.dup.merge({extra: 'extra-column'})
      different_keys.delete(:integer) # remove one column
      input = 10.times.map { |_| hash } + [different_keys]
      expect {subject.for_array(input)}.to raise_error(ArgumentError, "different key entries not (yet) supported")
    end
    it 'ignores nil values' do
      input = [hash.dup.merge({date: nil})] + 10.times.map { |_| hash } + [hash.dup.merge({integer: nil})]
      schema = subject.for_array(input)
      expect(schema).to eq(expected_schema)
    end
    it 'set type to Object when all values are nil for one key' do
      input = [hash.merge({allnil: nil})]
      schema = subject.for_array input
      expect(schema[:allnil]).to eq(Object)
    end
    it 'returns empty hash when given empty array' do
      expect(subject.for_array([])).to eq({})
    end
  end

end
