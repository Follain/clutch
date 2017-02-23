require "spec_helper"

describe Clutch, vcr: true do
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

  describe ".release_hold" do
    it "POSTS to release the balance correctly" do
      card = Clutch.allocate(card_set_id: "FollTest01")
      issue = Clutch.issue(card_number: card.cardNumber, dollars: 10.99)
      hold = Clutch.hold(card_number: card.cardNumber, dollars: 1.99)
      release = Clutch.release_hold(
        card_number: card.cardNumber,
        dollars: 0,
        hold_transaction_id: hold.transactionId
      )

      expect(release).to be_success
    end
  end

  describe ".search" do
    it "returns matching cards" do
      search = Clutch.search(filters: { cardNumber: 483109705813926 }, returnFields: {})
      expect(search).to be_success
      expect(search.cards.size).to eq 1
    end
  end

  describe ".validate" do
    context "with valid pin" do
      it "returns matching cards" do
        validate = Clutch.validate(filters: { cardNumber: 483140395030281 }, pin: 8422, returnFields: {})
        expect(validate).to be_success
        expect(validate.cards.size).to eq 1
      end
    end

    context "with NOT valid pin" do
      it "returns error" do
        expect{
          Clutch.validate(filters: { cardNumber: 483140395030281 }, pin: 0000, returnFields: {})
        }.to raise_error(Clutch::ResponseException)
      end
    end

    context "with NOT valid number" do
      it "returns nothing" do
        validate = Clutch.validate(filters: { cardNumber: 4831403 }, pin: 8422, returnFields: {})
        expect(validate).to be_success
        expect(validate.cards.size).to eq 0
      end
    end
  end
end
