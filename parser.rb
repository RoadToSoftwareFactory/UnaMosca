class Parser
  def self.parse(filename)
    start = nil
    flights = []
    cities = []

    File.readlines(filename).each do |line|
      if start.nil?
        start = line.chomp
        next
      end
      from, to, day, price = *line.split(/\s+/)
      if flights[day.to_i] == nil
        flights[day.to_i] = []
      end
      flights[day.to_i].push(Flight.new(from, to, day, price))
      cities.push(from)
      cities.push(to)
      end
    flights.first.delete_if{ |flight| flight.from != start }
    flights.last.delete_if{ |flight| flight.to != start }
    cities.uniq!

    {:start => start, :flights => flights, :days => flights.length, :cities => cities}
  end
end
