module Discount

  THRESHOLD = 30.freeze
  MULTIPLE_EXPRESS_COST = 15.freeze

  def eligible_for_bulk_discount?(cost)
    cost > THRESHOLD
  end

  def update_express_delivery_price(delivery)
    delivery.price = MULTIPLE_EXPRESS_COST if delivery.name == :express
  end

  def multiple_express_deliveries?(items)
    items.count { |(_, delivery)| delivery.name == :express } > 1
  end

end
