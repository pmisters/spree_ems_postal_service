begin
  RS_TO_USD = 114
  SEED_DATA = File.join(File.dirname(__FILE__), "sample", "ems.yml")
  abort "Unable load the sample data from the file: #{SEED_DATA}" unless File.exists? SEED_DATA
  
  prices = YAML.load_file SEED_DATA
  
  prices.each do |price|
    country = Country.find_by_name(price[:country])
    puts "Unknown country: #{price[:country]}" if country.nil?
    
    puts "Process: #{price[:country]}"
    
    zone = Zone.find_by_name price[:country]
    if zone.nil?
      zone_member = ZoneMember.new
      zone_member.zoneable_type = "Country"
      zone_member.zoneable_id = country.id
      
      zone = Zone.new
      zone.name = price[:country]
      zone.description = "#{price[:country]} for EMS"
      zone.members << zone_member
      zone.save
      puts "... new zone: #{zone.name}"
    end
    
    shipping = ShippingMethod.find_by_zone_id zone
    if shipping.nil? || shipping.calculator.class != Calculator::EmsPostalService
      shipping = ShippingMethod.new
      shipping.zone_id = zone.id
      shipping.name = "Expedited Mail Service"
      shipping.calculator = Calculator::EmsPostalService.new
      shipping.save
      puts "... new shipping method"
    end
    
    puts "... update calculator preferences"
    shipping.calculator.preferred_price_250 = price[:price_250].nil? ? 0 : ("%.2f" % (price[:price_250]/RS_TO_USD)).to_f
    shipping.calculator.preferred_price_500 = price[:price_500].nil? ? 0 : ("%.2f" % (price[:price_500]/RS_TO_USD)).to_f
    shipping.calculator.preferred_price_1000 = price[:price_1000].nil? ? 0 : ("%.2f" % (price[:price_1000]/RS_TO_USD)).to_f
    shipping.calculator.preferred_price_additional = price[:price_additional].nil? ? 0 : ("%.2f" % (price[:price_additional]/RS_TO_USD)).to_f
    shipping.save
  end
  
rescue
  puts $!.to_s
  p $!.backtrace
end