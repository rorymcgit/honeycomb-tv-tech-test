require './models/order'

describe Order do
  subject { Order.new material, discount }
  let(:discount) { double 'discount' }
  let(:material) { double 'material' }
  let(:broadcaster) { double 'broadcaster' }
  let(:standard_delivery) { double 'delivery' }

  before do
    allow(material).to receive(:identifier) { 'HON/TEST001/010' }
    allow(broadcaster).to receive(:id) { 1 }
    allow(broadcaster).to receive(:name) { 'Viacom' }
    allow(standard_delivery).to receive(:name) { :standard }
    allow(standard_delivery).to receive(:price) { 10 }
    allow(discount).to receive(:eligible_for_bulk_discount?) { false }
    allow(discount).to receive(:multiple_delivery_threshold) { 1 }
  end

  context 'empty' do
    it 'costs nothing' do
      expect(subject.total_cost).to eq(0)
    end
  end

  context 'adding to order' do
    it 'adding increases items count by one' do
      expect{subject.add broadcaster, standard_delivery}.to change{subject.items.length}.by(1)
    end
  end
end
