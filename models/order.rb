require './models/printer'

class Order

  attr_accessor :material, :items, :discount

  def initialize(material, discount)
    self.material = material
    self.discount = discount
    self.items = []
  end

  def add(broadcaster, delivery)
    items << [broadcaster, delivery]
    discount.reduce_express_price(delivery) if multiple_deliveries?(:express)
  end

  def total_cost
    discount.eligible_for_bulk_discount?(subtotal) ? discount.reduce_total_price(subtotal) : subtotal
  end

  def output(printer = Printer.new)
    printer.invoice(self, material, discount)
  end

  private

  def subtotal
    items.inject(0) { |memo, (_, delivery)| memo += delivery.price }
  end

  def multiple_deliveries?(delivery_type)
    items.count { |(_, delivery)| delivery.name == delivery_type } > 1
  end
end
