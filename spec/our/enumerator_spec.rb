require "our/enumerator"

describe Our::Enumerator do
  it "works" do
    enum = described_class.new do |yielder|
      i = 0
      loop do
        yielder.yield(i)
        i += 1
      end
    end

    expect(enum.take(3)).to eq([0, 1, 2])
  end
end
