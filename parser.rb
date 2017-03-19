class Parser
  def self.parse(filename)
    start = nil
    flights = []
    cities = Set.new

    File.readlines(filename).each do |line|
      if start.nil?
        start = line.chomp.to_sym
        next
      end

      from, to, day, price = *line.split(' ')
      from = from.to_sym
      to = to.to_sym
      day = day.to_i
      price = price.to_i

      flights[day] ||= {}
      flights[day][from] ||= {}
      flights[day][from][to] = Flight.new(from, to, day, price)

      cities.add(from)
      cities.add(to)
    end

    {:start => start, :flights => flights, :days => flights.length, :cities => cities}
  end
end
