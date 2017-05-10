require './models/discount'

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
    if delivery.name == :express && multiple_express_deliveries?
      discount.update_express_delivery_price(delivery)
    end
  end

  def total_cost
    if discount.eligible_for_bulk_discount?(pre_discount_cost)
      @discount_applied = true
      pre_discount_cost * (1 - discount.bulk_reduction)
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
      result << bulk_discount_message if @discount_applied
    end.join("\n")
  end

  private

  def bulk_discount_message
    "Bulk order discount of #{(discount.bulk_reduction * 100).to_i}% applied."
  end

  def pre_discount_cost
    items.inject(0) do |memo, (_, delivery)|
      memo += delivery.price
    end
  end

  def multiple_express_deliveries?
    items.count { |(_, delivery)| delivery.name == :express } > 1
  end

  def output_separator
    @output_separator ||= COLUMNS.map { |_, width| '-' * width }.join(' | ')
  end
end
