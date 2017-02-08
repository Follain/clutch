module Clutch
  class ResponseException < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end
  end
end
