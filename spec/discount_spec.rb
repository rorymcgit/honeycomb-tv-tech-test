require './models/discount'

describe Discount do
  subject { Discount.new }

  context 'eligible for bulk discount' do
    it 'returns true when over the default limit of 30' do
      expect(subject.eligible_for_bulk_discount?(40)).to eq(true)
    end

    it 'returns false when under the default limit of 30' do
      expect(subject.eligible_for_bulk_discount?(20)).to eq(false)
    end
  end

  context 'reduce total price' do
    it 'applies a 10% discount' do
      expect(subject.reduce_total_price(50)).to be(45.0)
    end

  end

  context 'july discount' do
    it 'returns true when the month is July', :time do
      july = Time.parse("2017-07-20 20:17:40")
      allow(Time).to receive(:now).and_return(july)
      expect(subject.is_july?).to eq(true)
    end

    it 'returns false when the month is not July', :time do
      january = Time.parse("2017-01-20 20:17:40")
      allow(Time).to receive(:now).and_return(january)
      expect(subject.is_july?).to eq(false)
    end

    it 'applies the July discount in july' do
      july = Time.parse("2017-07-20 20:17:40")
      allow(Time).to receive(:now).and_return(july)
      expect(subject.reduce_total_price(100)).to eq(80.0)
    end

    it 'does not apply the July discount in a different month' do
      january = Time.parse("2017-01-20 20:17:40")
      allow(Time).to receive(:now).and_return(january)
      expect(subject.reduce_total_price(100)).to eq(90.0)
    end
  end
end
