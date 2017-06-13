require "our/enumerator"

[Our::Enumerator, ::Enumerator].each do |klass|
  describe klass do
    subject {
      described_class.new do |yielder|
        i = 0
        loop do
          yielder.yield(i)
          i += 1
        end
      end
    }

    describe "#next" do
      it "gives the next item" do
        expect(subject.next).to eq(0)
        expect(subject.next).to eq(1)
        expect(subject.next).to eq(2)
        expect(subject.next).to eq(3)
      end
    end

    describe "#take" do
      it "takes the first n yielded items" do
        expect(subject.take(3)).to eq([0, 1, 2])
        expect(subject.take(3)).to eq([0, 1, 2])
      end
    end
  end
end
