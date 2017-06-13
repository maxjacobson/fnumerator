require "our/enumerator"

[Our::Enumerator, ::Enumerator].each do |klass|
  describe klass do
    context "infinite loops" do
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


    context "finite loops" do
      describe "#next" do
        subject {
          described_class.new do |yielder|
            [4, nil, 5].each do |obj|
              yielder.yield(obj)
            end
          end
        }

        it "raises a nice error" do
          expect(subject.next).to eq(4)
          expect(subject.next).to eq(nil)
          expect(subject.next).to eq(5)
          expect { subject.next }.to raise_error StopIteration, "iteration reached an end"
          expect { subject.next }.to raise_error StopIteration, "iteration reached an end"
        end
      end
    end
  end
end
