require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require './lib/dock'

class DockTest < Minitest::Test
  def test_it_exists
    dock = Dock.new("The Rowing Dock", 3)
    assert_instance_of Dock, dock
  end

  def test_it_has_readable_attributes
    dock = Dock.new("The Rowing Dock", 3)
    assert_equal "The Rowing Dock", dock.name
    assert_equal 3, dock.max_rental_time
  end

  def test_renter_can_rent_boats
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock = Dock.new("The Rowing Dock", 3)

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)

    result = {
      kayak_1 => patrick,
      kayak_2 => patrick,
      sup_1 => eugene
    }
    assert_equal result, dock.rental_log
  end

  def test_it_can_add_hours_rented
    # skip
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)

    2.times {kayak_1.add_hour}

    result = {
      :card_number => "4242424242424242",
      :amount => 40
    }

    assert_equal result, dock.charge(kayak_1)

    5.times { sup_1.add_hour }
    result = {
      :card_number => "1313131313131313",
      :amount => 45
    }

    assert_equal result, dock.charge(sup_1)
  end

  def test_it_can_log_hours
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)

    assert_equal 0, kayak_1.hours_rented
    assert_equal 0, kayak_2.hours_rented

    dock.log_hour

    assert_equal 1, kayak_1.hours_rented
    assert_equal 1, kayak_2.hours_rented

    dock.rent(canoe, patrick)
    dock.log_hour

    assert_equal 2, kayak_1.hours_rented
    assert_equal 2, kayak_2.hours_rented
    assert_equal 1, canoe.hours_rented
  end

  def test_revenue_can_be_read
    dock = Dock.new("The Rowing Dock", 3)
    assert_equal 0, dock.revenue
  end

  def test_boats_can_be_returned
    # skip
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    result = {kayak_1 => patrick, kayak_2 => patrick}
    assert_equal result, dock.rental_log

    dock.return(kayak_1)
    result = {kayak_2 => patrick}
    assert_equal result, dock.rental_log
  end

  def test_revenues_can_be_collected
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.log_hour
    dock.rent(canoe, patrick)
    dock.log_hour
    assert_equal 0, dock.revenue

    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)

    assert_equal 105, dock.revenue

    dock.rent(sup_1, eugene)
    dock.rent(sup_2, eugene)

    5.times {dock.log_hour}
    dock.return(sup_1)
    dock.return(sup_2)

    assert_equal 195, dock.revenue
  end
end
