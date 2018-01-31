class HintCounter
  attr_reader :total_num_hints, :hints_left

  def initialize(num_hints)
    @total_num_hints = num_hints
    @hints_left = num_hints
  end

  def new_hint_given
    @hints_left -= 1
  end

  def retract_hint
    @hints_left += 1
  end
end
