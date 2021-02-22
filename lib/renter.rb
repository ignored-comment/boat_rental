class Renter
  attr_reader :name, :credit_card_number

  def initialize(name, card)
    @name = name
    @credit_card_number = card
  end
end
