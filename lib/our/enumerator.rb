module Our
  class Yielder
    PENDING_OBJ = Object.new.freeze

    class << self
      attr_accessor :obj
    end

    def yield(obj)
      Yielder.obj  = obj
      Fiber.yield
    end
  end
end

module Our
  class Enumerator
    def initialize(&block)
      @orig_block = block
      @block = Fiber.new { block.dup.call(Yielder.new) }
    end

    def next
      Yielder.obj = Yielder::PENDING_OBJ
      block.resume
      if Yielder.obj == Yielder::PENDING_OBJ
        raise StopIteration, "iteration reached an end"
      else
        Yielder.obj
      end
    rescue FiberError
      raise StopIteration, "iteration reached an end"
    end

    def take(n)
      b = self.class.new(&orig_block)
      n.times.map { b.next }
    end

    private

    attr_reader :block, :orig_block
  end
end
