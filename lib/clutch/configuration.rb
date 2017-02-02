module Clutch
  class Configuration
    attr_accessor :clutch_api_key,
                  :clutch_api_secret,
                  :clutch_api_base,
                  :clutch_brand,
                  :clutch_location,
                  :clutch_terminal,
                  :clutch_card_set,
                  :http_proxy

    def initialize
      @clutch_api_key = nil
      @clutch_api_secret = nil
      @clutch_api_base = nil
      @clutch_brand = nil
      @clutch_location = nil
      @clutch_terminal = nil
      @clutch_card_set = nil
      @http_proxy = nil
    end
  end
end
