class Calculator::EmsPostalService < Calculator
  preference :price_250, :float, :default => 0
  preference :price_500, :float, :default => 0
  preference :price_1000, :float, :default => 0
  preference :price_additional, :float, :default => 0
  preference :handling_tax, :float, :default => 2
  
  WEIGHT_LIMIT = 1
  WEIGHT_STEP = 0.5
  
  def self.description
    "Expedited Mail Service"
  end
  
  def self.register
    super
    ShippingMethod.register_calculator self
  end
  
  def available(order)
    true
  end
  
  def additional_packs(weight)
    ((weight - WEIGHT_LIMIT) / WEIGHT_STEP).ceil
  end
  
  def compute(order)
    debug = false
    puts order.number if debug
    
    total_weight = 0
    order.line_items.each do |item|
      total_weight += item.variant.weight * item.quantity
    end
    puts "Weight: #{total_weight}" if debug

    shipping = calculate_price_for total_weight
    puts "Shipping: #{shipping}" if debug
    return shipping
  end
  
  def calculate_price_for(weight)
    shipping = 0
    case weight
    when 0..0.25
      shipping = self.preferred_price_250
    when 0.25..0.5
      shipping = self.preferred_price_500
    when 0.5..1
      shipping = self.preferred_price_1000
    else
      shipping = self.preferred_price_1000 + self.preferred_price_additional * additional_packs(weight)
    end
    return shipping + self.preferred_handling_tax
  end
end