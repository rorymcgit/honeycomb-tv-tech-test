class Discount

  HUNDRED_PCT = 100.0

  attr_accessor :bulk_threshold, :bulk_reduction_pct, :express_discount_price
  attr_reader :bulk_discount_applied, :express_delivery_discounted

  def initialize(bulk_threshold = 30,
                 bulk_reduction_pct = 10,
                 express_discount_price = 15)
    self.bulk_threshold = bulk_threshold
    self.bulk_reduction_pct = bulk_reduction_pct / HUNDRED_PCT
    self.express_discount_price = express_discount_price
  end

  def eligible_for_bulk_discount?(cost)
    cost > bulk_threshold
  end

  def reduce_total_price(cost)
    @bulk_discount_applied = true
    cost * (1 - bulk_reduction_pct)
  end

  def reduce_express_price(delivery)
    @express_delivery_discounted = true
    delivery.price = express_discount_price if delivery.name == :express
  end

  def bulk_discount_message
    "Bulk order discount of #{(bulk_reduction_pct * HUNDRED_PCT).to_i}% applied."
  end

  def multiple_express_discount_message
    "Express deliveries reduced to $#{express_discount_price} each."
  end

end
