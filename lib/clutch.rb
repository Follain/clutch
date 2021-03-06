require "faraday"
require "faraday_middleware"
require "clutch/version"
require "clutch/client"
require "clutch/response_exception"
require "clutch/configuration"

module Clutch
  class << self
    attr_accessor :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def client
      @client ||= Client.new
    end

    def allocate(card_set_id:)
      client.post "/allocate", cardSetId: card_set_id
    end

    def hold(card_number:, dollars:)
      update_balance card_number, dollars, :hold
    end

    def history(card_number:)
      client.post "/cardHistory", cardNumber: card_number
    end

    def issue(card_number:, dollars:, is_return_related: false)
      update_balance card_number, dollars, "issue", is_return_related: is_return_related
    end

    def redeem(card_number:, dollars:)
      update_balance card_number, dollars, "redeem"
    end

    def redeem_hold(card_number:, dollars:, hold_transaction_id:)
      update_balance card_number, dollars, "redeem", hold_transaction_id: hold_transaction_id
    end

    def release_hold(card_number:, dollars:, hold_transaction_id:)
      update_balance card_number, dollars, "redeem", hold_transaction_id: hold_transaction_id, release_hold_remainder: true
    end

    def search(filters:, returnFields:)
      client.post "/search", filters: filters, returnFields: returnFields
    end

    def find(card_number:)
      result = history(card_number: card_number)
      if (result.success)
        card = search(
          filters: { cardNumber: card_number },
          returnFields: {
            balances: true,
            checkouts: true,
            customData: true,
            activationDate: true
          }
        ).cards.first

        card.activated = true
        return card
      end

      case result.errorMessage
      when 'Could not find the specified card.'
        raise Clutch::ResponseException.new(result), result.errorMessage
      when 'Could not find the account that goes with the specified card.'
        return { cardNumber: card_number, activated: false, balances: [] }
      else
        raise Clutch::ResponseException.new(result), result.errorMessage
      end
    end

    def validate(filters:, returnFields:, pin:)
      response = client.post "/search", filters: filters, returnFields: returnFields, forcePinValidation: true, pin: pin
      raise Clutch::ResponseException.new(response), response.errorMessage unless response.success?
      response
    end

    private

    def update_balance(card_number, dollars, action, hold_transaction_id: nil, is_return_related: false, release_hold_remainder: false)
      client.post "/updateBalance",
        cardNumber: card_number,
        action: action,
        redeemFromHoldTransactionId: hold_transaction_id,
        releaseHoldRemainder: release_hold_remainder,
        isReturnRelated: is_return_related,
        amount: {
          balanceType: "Currency",
          balanceCode: "USD",
          amount: dollars
        }
    end
  end
end
