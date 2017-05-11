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
    if delivery.name == :express && multiple_deliveries?(:express)
      discount.reduce_express_price(delivery)
    end
  end

  def total_cost
    if discount.eligible_for_bulk_discount?(pre_discount_cost)
      @bulk_discount_applied = true
      pre_discount_cost * (1 - discount.bulk_reduction_pct)
    else
      pre_discount_cost
    end
  end

  def output
    [].tap do |result|
      result << "Order for #{material.identifier}:"

      result << COLUMNS.map { |name, width| name.to_s.ljust(width) }.join(' | ')
      result << output_separator

      items.each_with_index do |(broadcaster, delivery), index|
        result << [
          broadcaster.name.ljust(COLUMNS[:broadcaster]),
          delivery.name.to_s.ljust(COLUMNS[:delivery]),
          ("$#{delivery.price}").ljust(COLUMNS[:price])
        ].join(' | ')
      end

      result << output_separator
      result << "Total: $#{total_cost}"
      result << discount.bulk_discount_message if @bulk_discount_applied
    end.join("\n")
  end

  private

  def pre_discount_cost
    items.inject(0) do |memo, (_, delivery)|
      memo += delivery.price
    end
  end

  def multiple_deliveries?(delivery_type)
    items.count { |(_, delivery)| delivery.name == delivery_type } > 1
  end

  def output_separator
    @output_separator ||= COLUMNS.map { |_, width| '-' * width }.join(' | ')
  end
end
