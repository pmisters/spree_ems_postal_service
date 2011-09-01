require "spree_ems_postal_service_hooks"

module SpreeEmsPostalService
  class Engine < Rails::Engine
    config.autoload_paths += %W(#{config.root}/lib)
    
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      require "calculator/ems_postal_service"
      Calculator::EmsPostalService.register
    end
    
    config.to_prepare &method(:activate).to_proc
  end
end