class Parser
  def self.parse(filename)
    start = nil
    flights = []

    File.readlines(filename).each do |line|
      if start.nil?
        start = line.chomp
        next
      end

      flights << Flight.new(*line.split(/\s+/))
    end

    {:start => start, :flights => flights}
  end
end
