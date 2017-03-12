class RandomGreedy < Greedy
  def get_cheapest(possible)
    sum = 0
    possible.each{|k,v| sum += 1.fdiv(v.price)}

    probabilities = {}
    possible.each do |k,v|
      probabilities[k] = (1.fdiv(v.price)).fdiv(sum)
    end
    random = rand
    zero = 0
    probabilities.each do |k, v|
      if (v + zero) >= random
        return [k,possible[k]]
      else
        zero += v
      end
    end
    possible.min_by{|k,v| v.price}
  end
end
