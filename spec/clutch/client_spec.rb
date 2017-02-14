require "spec_helper"

RSpec.describe Clutch::Client do
  before do
    Clutch.configure do |c|
      c.clutch_brand = "cool-brand"
      c.clutch_location = "ecommerce"
      c.clutch_terminal = "ecommerce-terminal"
    end
  end

  describe "#headers" do
    subject(:headers) { Clutch::Client.new.headers }

    it "pulls brand, location, and terminal from environment variables" do
      expect(headers['brand']).to eq 'cool-brand'
      expect(headers['location']).to eq 'ecommerce'
      expect(headers['terminal']).to eq 'ecommerce-terminal'
    end
  end
end
