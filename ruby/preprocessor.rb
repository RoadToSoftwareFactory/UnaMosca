class Preprocessor
  def self.filter(magic, start:, days:, flights:, cities:)
    flights.each_with_index do |froms, day|
      froms.keys.each do |from|
        froms.delete(from) unless magic[day][:from].include?(from)
      end

      froms.each do |from, tos|
        tos.keys.each do |to|
          tos.delete(to) unless magic[day][:to].include?(to)
        end

        froms.delete(from) if tos.keys.empty?
      end
    end

    flights
  end

  def self.magic_backward(start:, days:, flights:, cities:)
    day = days - 1
    targets = Set.new([start])
    magic = []

    while day >= 0 do
      next_targets = Set.new

      magic[day] = {:from => next_targets, :to => targets}

      flights[day].each do |from, destinations|
        intersection = targets & Set.new(destinations.keys)
        next if intersection.empty?

        next_targets.add(from) if day == 0 || from != start
      end

      targets = next_targets
      day -= 1
    end

    magic[0][:from] = Set.new([start])

    magic
  end

  def self.magic_forward(start:, days:, flights:, cities:)
    day = 0
    sources = Set.new([start])
    magic = []

    while day < days do
      next_sources = Set.new

      magic[day] = {:from => sources, :to => next_sources}

      flights[day].each do |from, destinations|
        next unless sources.include? from

        next_sources.merge(destinations.keys)
      end

      sources = next_sources
      day += 1
    end

    magic[days - 1][:to] = Set.new([start])

    magic
  end

  def self.magic(args)
    forward = magic_forward(args)
    backward = magic_backward(args)

    0.upto(args[:days] - 1).map do |day|
      {:from => forward[day][:from] & backward[day][:from],
       :to => forward[day][:to] & backward[day][:to]}
    end
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
    magic = magic(args)
    result = filter(magic, args)
    after = count(result)

    verify(args)

    $stderr.puts([before, after, ((after.to_f / before.to_f) * 100).to_i.to_s + "%"].inspect)

    result
  end
end
