class Order
  COLUMNS = {
    broadcaster: 20,
    delivery: 8,
    price: 8
  }.freeze

  attr_accessor :material, :items

  def initialize(material)
    self.material = material
    self.items = []
    @express_delivery_counter = 0
  end

  def add(broadcaster, delivery)
    @express_delivery_counter += 1 if delivery.name == :express
    update_express_delivery_price
    items << [broadcaster, delivery]
  end

  def total_cost
    eligible_for_bulk_discount? ? pre_discount_cost - pre_discount_cost / 10.0 : pre_discount_cost
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

  def eligible_for_bulk_discount?
    pre_discount_cost > 30
  end

  def multiple_express_deliveries?
    @express_delivery_counter > 1
  end

  def pre_discount_cost
    items.inject(0) do |memo, (_, delivery)|
      delivery.price = 15 if delivery.name == :express && multiple_express_deliveries?
      memo += delivery.price
    end
  end

  def update_express_delivery_price
    items.each do |(_, delivery)|
      delivery.price = 15.0 if delivery.name == :express && multiple_express_deliveries?
    end
  end

  def output_separator
    @output_separator ||= COLUMNS.map { |_, width| '-' * width }.join(' | ')
  end
end
