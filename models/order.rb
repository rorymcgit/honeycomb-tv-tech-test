class Order

  COLUMNS = {
    broadcaster: 20,
    delivery: 8,
    price: 8
  }.freeze

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

  def output
    [].tap do |result|
      result << "Order for #{material.identifier}:"

      result << header
      result << output_separator

      items.each do |(broadcaster, delivery)|
        result << [
          broadcaster.name.ljust(COLUMNS[:broadcaster]),
          delivery.name.to_s.ljust(COLUMNS[:delivery]),
          ("$#{delivery.price}").ljust(COLUMNS[:price])
        ].join(' | ')
      end

      result << output_separator
      result << "Total: $#{total_cost}"
      result << discount.bulk_discount_message if discount.bulk_discount_applied
      result << discount.multiple_express_discount_message if discount.express_delivery_discounted
    end.join("\n")
  end

  private

  def subtotal
    items.inject(0) { |memo, (_, delivery)| memo += delivery.price }
  end

  def multiple_deliveries?(delivery_type)
    items.count { |(_, delivery)| delivery.name == delivery_type } > 1
  end

  def header
    COLUMNS.map { |name, width| name.to_s.ljust(width) }.join(' | ')
  end

  def output_separator
    COLUMNS.map { |_, width| '-' * width }.join(' | ')
  end
end
