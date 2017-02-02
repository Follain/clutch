require "spec_helper"

describe Clutch, vcr: true do
  before do
    Clutch.configure do |c|
      c.clutch_api_key = ENV.fetch("CLUTCH_API_KEY")
      c.clutch_api_secret = ENV.fetch("CLUTCH_API_SECRET")
      c.clutch_api_base = ENV.fetch("CLUTCH_API_BASE")
      c.clutch_brand = ENV.fetch("CLUTCH_BRAND")
      c.clutch_location = ENV.fetch("CLUTCH_LOCATION")
      c.clutch_terminal = ENV.fetch("CLUTCH_TERMINAL")
    end
  end

  describe ".allocate" do
    it "returns a card" do
      card = Clutch.allocate(card_set_id: "FollTest01")
      expect(card).to be_success
      expect(card.cardNumber).to be_truthy
      expect(card.pin).to be_truthy
    end
  end

  describe ".hold" do
    it "POSTS to hold the balance correctly" do
      card = Clutch.allocate(card_set_id: "FollTest01")
      issue = Clutch.issue(card_number: card.cardNumber, dollars: 10.99)
      hold = Clutch.hold(card_number: card.cardNumber, dollars: 1.99)
      expect(hold).to be_success
    end
  end

  describe ".issue" do
    it "adds `dollars` to the card" do
      card = Clutch.allocate(card_set_id: "FollTest01")
      issue = Clutch.issue(card_number: card.cardNumber, dollars: 10.99)
      expect(issue).to be_success
    end
  end

  describe ".redeem" do
    it "POSTS to update the balance correctly" do
      card = Clutch.allocate(card_set_id: "FollTest01")
      issue = Clutch.issue(card_number: card.cardNumber, dollars: 10.99)
      redemption = Clutch.redeem(card_number: card.cardNumber, dollars: 4.99)
      expect(redemption).to be_success
    end

    context "without a card number" do
      it "returns an object with errors" do
        redemption = Clutch.redeem(card_number: '', dollars: 10)
        expect(redemption).not_to be_success
      end
    end
  end

  describe ".redeem_hold" do
    it "POSTS to update the balance correctly" do
      card = Clutch.allocate(card_set_id: "FollTest01")
      issue = Clutch.issue(card_number: card.cardNumber, dollars: 10.99)
      hold = Clutch.hold(card_number: card.cardNumber, dollars: 1.99)
      redemption = Clutch.redeem_hold(
        card_number: card.cardNumber,
        dollars: 1.99,
        hold_transaction_id: hold.transactionId
      )

      expect(redemption).to be_success
    end
  end

  describe ".search" do
    it "returns matching cards" do
      search = Clutch.search(filters: { cardNumber: 483109705813926 }, returnFields: {})
      expect(search).to be_success
      expect(search.cards.size).to eq 1
    end
  end
end
