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
end
