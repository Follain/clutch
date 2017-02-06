
RSpec.configure do |config|
  config.before do
    Clutch.configure do |c|
      c.clutch_api_key = "KEY"
      c.clutch_api_secret = "SECRET"
      c.clutch_api_base = "https://api-test.profitpointinc.com:9002/merchant/"
      c.clutch_brand = "BRAND"
      c.clutch_location = "LOCATION"
      c.clutch_terminal = "TERMINAL"
    end
  end
end
