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

        next_targets.add(from) if day == 0 || from != start

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

  def self.verify(start:, flights:, days:, **_)
    raise "lety jen ze startovniho mesta prvni den" if flights[0].keys != [start]

    flights.each_with_index do |day, index|
      next if index == 0

      raise "zadne lety ze startovniho mesta mimo prvni den" if day.keys.include? start
    end

    raise "lety jen do startovniho mesta posledni den" if flights[days - 1].values.map(&:keys).flatten.uniq != [start]

    flights.each_with_index do |day, index|
      next if index == days - 1

      raise "zadne lety do startovniho mesta mimo posledni den" if day.values.map(&:keys).include? start
    end
  end

  def self.process(args)
    before = count(args[:flights])
    result = stuff(args)
    after = count(result)

    verify(args)

    $stderr.puts([before, after, ((after.to_f / before.to_f) * 100).to_i.to_s + "%"].inspect)

    result
  end
end
