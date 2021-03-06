class Greedy < Algo
  def get_cheapest(possible)
    possible.min_by { |v| v.price }
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

      possible = @flights[day][current].values.select do |f|
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

      cheapest = get_cheapest(possible)

      path << cheapest
      current = cheapest.to
      visited.add current
      day += 1
    end

    path
  end
end
