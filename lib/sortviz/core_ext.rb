# TODO: Use refinements
class Array
  def versions
    @versions ||= Array.new
  end

  def swap!(a, b)
    self[a], self[b] = self[b], self[a]
    mark_version(b)
  end

  private
  # idx: Current selection index
  def mark_version(idx)
    versions << [self.dup, idx]
  end
end