class Flight < Struct.new(:from, :to, :day, :price)
  def to_s
    "#{from} #{to} #{day} #{price}"
  end
end
