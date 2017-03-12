class Preprocessor
  def self.stuff(start:, days:, flights:, cities:)
    day = days - 1
    targets = Set.new([start])

    while day >= 0 do
      p({ :day => day, :targets => targets })
      next_targets = Set.new

      flights[day].each do |from, destinations|
        intersection = targets & Set.new(destinations.keys)
        next if intersection.empty?

        next_targets.add(from)

        destinations.keys.each do |to|
          destinations.delete(to) unless targets.include?(to)
        end
      end

      flights[day].keys.each do |from|
        flights[day].delete(from) unless next_targets.include?(from)
      end

      targets = next_targets
      day -= 1
    end

    flights[0].keys.each do |from|
      flights[0].delete(from) unless from == start
    end

    flights
  end

  def self.count(data)
    data.map do |day|
      day.values.map do |city|
        city.values.length
      end.reduce(:+)
    end.reduce(:+)
  end

  def self.process(args)
    before = count(args[:flights])
    result = stuff(args)
    after = count(result)

    $stderr.puts([before, after, ((after.to_f / before.to_f) * 100).to_i.to_s + "%"].inspect)

    result
  end
end
