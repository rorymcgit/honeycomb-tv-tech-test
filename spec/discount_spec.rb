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
end
