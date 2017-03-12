class Greedy < Algo
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

      possible = @flights[day][current.to_sym].select do |f|
        !visited.include?(f.to_s) and
        !blacklist[day].include?(f.to_s)
      end

      if possible.empty?
        visited.delete(current.to_s)
        last = path.pop
        current = last.from

        day -= 1
        blacklist[day].add last.to_s

        next
      end

      cheapest = possible.min_by{|k,v| v.price}

      path << possible[cheapest.first]
      current = cheapest.last.to
      visited.add current.to_s
      day += 1
    end

    path
  end
end
