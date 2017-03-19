class RandomGreedy < Greedy
  def get_cheapest(possible)
    sum = 0
    possible.each { |v| sum += 1.fdiv(v.price) }

    probabilities = []
    possible.each do |v|
      probabilities << (1.fdiv(v.price)).fdiv(sum)
    end

    random = rand
    zero = 0
    probabilities.each_with_index do |v, i|
      if (v + zero) >= random
        return possible[i]
      else
        zero += v
      end
    end

    possible.min_by { |v| v.price }
  end
end
