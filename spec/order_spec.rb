require './models/order'

describe Order do
  subject { Order.new material }
  let(:material) { double 'material' }

  before do
    allow(material).to receive(:identifier) { 'HON/TEST001/010' }
  end

  context 'Discount module' do
    it 'is included in the Order class' do
      expect((class << subject; self; end).included_modules.first).to eq(Discount)
    end
  end

  context 'empty' do
    it 'costs nothing' do
      expect(subject.total_cost).to eq(0)
    end
  end
end
