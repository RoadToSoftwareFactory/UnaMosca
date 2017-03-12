class Preprocessor
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
      flights.each_with_index do |f, index|
        f.delete_if do |flight|
          if index == 0
            no_way = !has_any_flight_out(flights, index, flight)
          elsif index + 1 == flights.length
            no_way = !has_any_flight_in(flights, index, flight)
          else
            no_way = !(has_any_flight_in(flights, index, flight) && has_any_flight_out(flights, index, flight))
          end
          stuff_to_remove = true if no_way
          no_way
        end
      end
    end

    flights
  end

  def self.process(start, flights)
    before = flights.flatten.length
    result = process_data(start, flights)
    after = result.flatten.length

    $stderr.print(before, after, ((after.to_f / before.to_f) * 100).to_i.to_s + "%")

    result
  end
end
