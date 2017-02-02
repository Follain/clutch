require "spec_helper"

RSpec.describe Client do
  before do
    Clutch.configure do |c|
      c.clutch_brand = "cool-brand"
      c.clutch_location = "ecommerce"
      c.clutch_terminal = "ecommerce-terminal"
    end
  end

  describe "#headers" do
    subject(:headers) { Client.new.headers }

    it "pulls brand, location, and terminal from environment variables" do
      expect(headers['brand']).to eq 'cool-brand'
      expect(headers['location']).to eq 'ecommerce'
      expect(headers['terminal']).to eq 'ecommerce-terminal'
    end
  end
end
