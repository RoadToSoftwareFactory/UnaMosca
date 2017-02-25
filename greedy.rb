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
    blacklist = []

    day = 0
    blacklist[day] = Set.new

    while day < @days
      blacklist[day + 1] = Set.new

      if day == @days - 1
        # last day, going to @start
        visited.delete(@start)
      end

      possible = @flights[day].select do |f|
        f.from == current and
        !visited.include?(f.to) and
        !blacklist[day].include?(f)
      end

      if possible.empty?
        visited.delete(current)
        last = path.pop
        current = last.from

        day -= 1
        blacklist[day].add last

        next
      end

      cheapest = possible.sort_by { |f| f.price }.first

      path << cheapest
      current = cheapest.to
      visited.add current

      day += 1
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
