class Dock
  attr_reader :name,
              :max_rental_time,
              :rental_log,
              :revenue

  def initialize(name, rental_time)
    @name = name
    @max_rental_time = rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    result = {}
    result[:card_number] = @rental_log[boat].credit_card_number
    if boat.hours_rented >= @max_rental_time
      result[:amount] = @max_rental_time * boat.price_per_hour
    else
      result[:amount] = boat.hours_rented * boat.price_per_hour
    end
    result
  end

  def log_hour
    @rental_log.each do |key, value|
      key.add_hour
    end
  end

  def return(boat)
    @revenue += charge(boat)[:amount]
    @rental_log.delete(boat)
    @revenue
  end

end
