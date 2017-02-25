class Greedy
  def initialize(start:, days:, flights:, cities:)
    @start = start
    @days = days
    @flights = flights
    @cities = cities
  end

  def run
    path = []
    current = @start
    visited = [current].to_set

    @days.times do |day|
      if day == @days - 1
        # last day, going to @start
        visited.delete(@start)
      end

      possible = @flights[day].select { |f| f.from == current and !visited.include?(f.to) }
      cheapest = possible.sort_by { |f| f.price }.first

      path << cheapest
      current = cheapest.to
      visited.add current
    end

    path
  end

  def path
    @path ||= run
  end

  def price
    path.map { |f| f.price }.reduce(:+)
  end
end
