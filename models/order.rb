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
    if discount.eligible_for_bulk_discount?(no_discount_cost)
      no_discount_cost * (1 - discount.bulk_reduction_pct)
    else
      no_discount_cost
    end
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
      result << discount.bulk_discount_message if discount.eligible_for_bulk_discount?(no_discount_cost)
      result << discount.multiple_express_discount_message if multiple_deliveries?(:express)
      result << output_separator
      result << "Total: $#{total_cost}"
    end.join("\n")
  end

  private

  def no_discount_cost
    items.inject(0) { |memo, (_, delivery)| memo += delivery.price }
  end

  def multiple_deliveries?(delivery_type)
    items.count { |(_, delivery)| delivery.name == delivery_type } > 1
  end

  def header
    COLUMNS.map { |name, width| name.to_s.ljust(width) }.join(' | ')
  end

  def output_separator
    @output_separator ||= COLUMNS.map { |_, width| '-' * width }.join(' | ')
  end
end
