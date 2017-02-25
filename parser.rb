class Parser
  def self.has_any_flight_out(flights, index, flight)
    flights[index + 1].any?{ |after_flight| after_flight.from == flight.to}
  end
  def self.has_any_flight_in(flights, index, flight)
    flights[index - 1].any?{ |before_flight| before_flight.to == flight.from}
  end

  def self.process_data(start, flights)
    flights.first.delete_if{ |flight| flight.from != start }
    flights.last.delete_if{ |flight| flight.to != start }
    stuff_to_remove = true
    while stuff_to_remove do
      stuff_to_remove = false
      flights.each_with_index { |f, index| f.delete_if do |flight|
        if index == 0
          no_way = !Parser.has_any_flight_out(flights, index, flight)
        elsif index + 1 == flights.length
          no_way = !Parser.has_any_flight_in(flights, index, flight)
        else
          no_way = !(Parser.has_any_flight_in(flights, index, flight) && Parser.has_any_flight_out(flights, index, flight))
        end
        stuff_to_remove = true if no_way
        no_way
      end
      }
    end

    flights
  end

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
      day = day.to_i
      price = price.to_i

      if flights[day] == nil
        flights[day] = []
      end

      flights[day].push(Flight.new(from, to, day, price))

      cities.push(from)
      cities.push(to)
    end
    before = flights.flatten.length
    flights = Parser.process_data(start, flights)
    after = flights.flatten.length
    binding.pry
    cities.uniq!

    {:start => start, :flights => flights, :days => flights.length, :cities => cities}
  end
end
