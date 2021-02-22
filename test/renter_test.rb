require 'minitest/autorun'
require 'minitest/pride'
require './lib/renter'

class RenterTest < Minitest::Test
  def test_it_exists
    renter = Renter.new(
      "Patrick",
      "4242424242424242"
    )
    assert_instance_of Renter, renter
  end

  def test_it_has_readable_attributes
    renter = Renter.new(
      "Patrick",
      "4242424242424242"
    )
    assert_equal "Patrick", renter.name
    assert_equal "4242424242424242", renter.credit_card_number
  end
end
