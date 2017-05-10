class Discount

  attr_accessor :bulk_threshold, :bulk_reduction, :express_discount_price

  def initialize(bulk_threshold = 30,
                 bulk_reduction = 0.1,
                 express_discount_price = 15)
    self.bulk_threshold = bulk_threshold
    self.bulk_reduction = bulk_reduction
    self.express_discount_price = express_discount_price
  end

  def eligible_for_bulk_discount?(cost)
    cost > bulk_threshold
  end

  def update_express_delivery_price(delivery)
    delivery.price = express_discount_price
  end

end
