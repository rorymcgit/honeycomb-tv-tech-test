require './models/broadcaster'
require './models/delivery'
require './models/material'
require './models/order'

describe 'Feature' do
  let(:order) { Order.new material }
  let(:material) { Material.new 'HON/TEST001/010' }
  let(:standard_delivery) { Delivery.new(:standard, 10) }
  let(:express_delivery) { Delivery.new(:express, 20) }

  context 'with items' do
    it 'returns the total cost of all items' do
      broadcaster_1 = Broadcaster.new(1, 'Viacom')
      broadcaster_2 = Broadcaster.new(2, 'Disney')

      order.add broadcaster_1, standard_delivery
      order.add broadcaster_2, express_delivery

      expect(order.total_cost).to eq(30)
    end
  end

  context 'bulk discount' do
    it 'applies a 10% discount on orders over $30' do
      broadcaster_1 = Broadcaster.new(1, 'Viacom')
      broadcaster_2 = Broadcaster.new(2, 'Disney')
      broadcaster_3 = Broadcaster.new(3, 'Discovery')

      order.add broadcaster_1, standard_delivery
      order.add broadcaster_2, standard_delivery
      order.add broadcaster_3, express_delivery

      expect(order.total_cost).to eq(36)
    end
  end

  context 'multiple express delivery' do
    it 'reduces cost of each express delivery to $15', :b do
      broadcaster_1 = Broadcaster.new(1, 'Viacom')
      broadcaster_2 = Broadcaster.new(2, 'Disney')

      order.add broadcaster_1, express_delivery
      order.add broadcaster_2, express_delivery

      expect(order.total_cost).to eq(30)
    end
  end
end
