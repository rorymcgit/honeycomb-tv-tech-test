require './models/broadcaster'
require './models/delivery'
require './models/material'
require './models/order'

describe 'Feature' do
  let(:order) { Order.new material, discount }
  let(:discount) { Discount.new }
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
    it 'reduces an express delivery cost to $15' do
      expect{discount.reduce_express_price(express_delivery)}.to change{express_delivery.price}.to(15)
    end

    it 'calculates order with discounted express deliveries' do
      broadcaster_1 = Broadcaster.new(1, 'Viacom')
      broadcaster_2 = Broadcaster.new(2, 'Disney')

      order.add broadcaster_1, express_delivery
      order.add broadcaster_2, express_delivery

      expect(order.total_cost).to eq(30)
    end
  end
end
