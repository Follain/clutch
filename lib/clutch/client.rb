module Clutch
  class Client
    module NeverCapitalize
      def capitalize!
        super
      end
    end

    HEADER_KEYS = %w[brand location terminal].map{ |key| key.extend(NeverCapitalize) }

    attr_reader :connection

    %w[api_key api_secret api_base brand location terminal card_set].each do |key|
      define_method key do
        Clutch.configuration.send("clutch_#{key}")
      end
    end


    def headers
      Hash[HEADER_KEYS.map{ |key| [key, send(key) ] }]
    end

    def initialize(connection = nil)
      @connection = connection || build_connection
    end

    def build_connection
      #opts = { ssl: { verify: false }, proxy: "http://localhost:8888" }
      opts = {}
      Faraday.new(api_base, opts) do |faraday|
        faraday.adapter :net_http
        faraday.request :json

        faraday.response :mashify
        faraday.response :json
      end.tap do |faraday|
        faraday.basic_auth api_key, api_secret
      end
    end

    def post(path, hash)
      response = connection.post(path, JSON.generate(hash)) do |conn|
        conn.headers.merge!(headers)
      end

      response.body
    end
  end
end
