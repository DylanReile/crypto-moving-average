require_relative '../poloniex'
require 'rspec'

describe Poloniex do
  describe '.running_average' do
    it 'keeps a running average' do
      samples = []
      running_average = described_class.running_average(10)
      (1..10).each do |i|
        samples << i
        expect(running_average.call(i)).to eq(samples.reduce(:+).to_f / samples.count)
      end
    end

    it 'does not include samples to the left of its window' do
      running_average = described_class.running_average(1)
      running_average.call(999)
      expect(running_average.call(1)).to eq(1)
    end
  end

  describe '.current_price' do
    before do
      allow(Poloniex).to receive(:current_pair_data) do
        { 'SUPPORTED_PAIR' => { 'last' => '0.4' } }
      end
    end

    context 'when the pair is supported' do
      it 'returns the last price' do
        expect(described_class.current_price('SUPPORTED_PAIR')).to eq(0.4)
      end
    end

    context 'when the pair is not supported' do
      it 'raises an ArgumentError' do
        expect{described_class.current_price('UNSUPPORTED_PAIR')}.to raise_error(ArgumentError)
      end
    end
  end
end
