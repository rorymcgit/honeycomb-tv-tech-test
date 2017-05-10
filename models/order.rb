require './models/discount'

class Order
  include Discount

  COLUMNS = {
    broadcaster: 20,
    delivery: 8,
    price: 8
  }.freeze

  attr_accessor :material, :items

  def initialize(material)
    self.material = material
    self.items = []
  end

  def add(broadcaster, delivery)
    items << [broadcaster, delivery]
    update_express_delivery_price(delivery) if multiple_express_deliveries?(items)
  end

  def total_cost
    eligible_for_bulk_discount?(pre_discount_cost) ? pre_discount_cost * 0.90 : pre_discount_cost
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
    end.join("\n")
  end

  private

  def pre_discount_cost
    items.inject(0) do |memo, (_, delivery)|
      memo += delivery.price
    end
  end

  def output_separator
    @output_separator ||= COLUMNS.map { |_, width| '-' * width }.join(' | ')
  end
end
