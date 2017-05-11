require './models/printer'

describe Printer do
  subject { Printer.new }
  let(:order) { double 'order' }
  let(:material) { double 'material' }
  let(:discount) { double 'discount' }
  let(:broadcaster) { double 'broadcaster' }
  let(:standard_delivery) { double 'delivery' }

  before do
    allow(material).to receive(:identifier) { 'HON/TEST001/010' }
    allow(broadcaster).to receive(:id) { 1 }
    allow(broadcaster).to receive(:name) { 'Viacom' }
    allow(standard_delivery).to receive(:name) { :standard }
    allow(standard_delivery).to receive(:price) { 10 }
    allow(order).to receive(:total_cost) { 20 }
    allow(order).to receive(:items) { [[broadcaster, standard_delivery]] }
    allow(discount).to receive(:bulk_discount_message) { nil }
    allow(discount).to receive(:multiple_express_discount_message) { nil }
  end

  context 'prints the invoice' do
    it 'contains the material ID' do
      expect(subject.invoice(order, material, discount)).to include(material.identifier)
    end
    it 'contains the total cost' do
      expect(subject.invoice(order, material, discount)).to include("#{order.total_cost}")
    end
    it 'contains the broadcaster name' do
      expect(subject.invoice(order, material, discount)).to include(broadcaster.name)
    end
    it 'contains the delivery name' do
      expect(subject.invoice(order, material, discount)).to include(standard_delivery.name.to_s)
    end
    it 'contains the delivery price' do
      expect(subject.invoice(order, material, discount)).to include("#{standard_delivery.price}")
    end
  end
end
