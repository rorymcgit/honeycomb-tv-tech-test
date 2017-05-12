class Printer

  COLUMNS = {
    broadcaster: 20,
    delivery: 8,
    price: 8
  }.freeze

  def invoice(order, material, discount)
    [].tap do |result|
      result << "Order for #{material.identifier}:"

      result << header
      result << output_separator

      order.items.each do |(broadcaster, delivery)|
        platforms(result, broadcaster, delivery)
      end

      result << output_separator
      result << "Total: $#{format('%.2f', order.total_cost)}"
      result << discount.bulk_discount_message
      result << discount.multiple_express_discount_message
    end.compact.join("\n")
  end

  private

  def platforms(result, broadcaster, delivery)
    result << [
      broadcaster.name.ljust(COLUMNS[:broadcaster]),
      delivery.name.to_s.ljust(COLUMNS[:delivery]),
      ("$#{format('%.2f', delivery.price)}").ljust(COLUMNS[:price])
    ].join(' | ')
  end

  def header
    COLUMNS.map { |name, width| name.to_s.ljust(width) }.join(' | ')
  end

  def output_separator
    COLUMNS.map { |_, width| '-' * width }.join(' | ')
  end

end
