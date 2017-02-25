class Algo
  def initialize(start:, days:, flights:, cities:)
    @start = start
    @days = days
    @flights = flights
    @cities = cities
  end

  def path
    @path ||= run
  end

  def price
    path.map { |f| f.price }.reduce(:+)
  end
end
