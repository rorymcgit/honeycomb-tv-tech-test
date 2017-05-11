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
    allow(discount).to receive(:bulk_discount_message) { nil }
    allow(discount).to receive(:multiple_express_discount_message) { nil }
    allow(order).to receive(:total_cost) { 20 }
    allow(order).to receive(:items) { [[broadcaster, standard_delivery]] }
    @invoice_output = subject.invoice(order, material, discount)
  end

  context 'the invoice' do
    it 'contains the material ID' do
      expect(@invoice_output).to include(material.identifier)
    end
    it 'contains the total cost' do
      expect(@invoice_output).to include("#{order.total_cost}")
    end
    it 'contains the broadcaster name' do
      expect(@invoice_output).to include(broadcaster.name)
    end
    it 'contains the delivery name' do
      expect(@invoice_output).to include(standard_delivery.name.to_s)
    end
    it 'contains the delivery price' do
      expect(@invoice_output).to include("#{standard_delivery.price}")
    end
  end
end
