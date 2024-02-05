# frozen_string_literal: true

RSpec.describe TealToad::Tensor do
  # Static helper methods
  describe ".fill" do
    it "returns a new instance of Tensor with the given shape containing the given value" do
      expect(described_class.fill([2, 2], 10)).to eq(described_class.new(shape: [2, 2], items: [10, 10, 10, 10]))
    end

    it "returns a new instance of Tensor with the given shape fileld with 0 if no fill argument is passed" do
      expect(described_class.fill([2, 2])).to eq(described_class.new(shape: [2, 2], items: [0, 0, 0, 0]))
    end
  end

  describe ".zeros" do
    it "returns a new instance of Tensor with the given shape containing 0" do
      expect(described_class.zeros([2, 2])).to eq(described_class.new(shape: [2, 2], items: [0, 0, 0, 0]))
    end
  end

  describe ".ones" do
    it "returns a new instance of Tensor with the given shape containing 1" do
      expect(described_class.ones([2, 2])).to eq(described_class.new(shape: [2, 2], items: [1, 1, 1, 1]))
    end
  end

  describe ".from" do
    let(:tensor) { described_class.new(shape: [2, 2, 2], items: [1, 2, 1, 2, 3, 4, 3, 4]) }

    context "when a Tensor is passed" do
      it "returns the same Tensor" do
        expect(described_class.from(tensor)).to eq(tensor)
        expect(described_class.from(tensor)).to be(tensor)
      end
    end

    context "when a Numeric is passed" do
      it "returns a Tensor" do
        expect(described_class.from(12)).to eq(described_class.new(shape: [1], items: [12]))
      end
    end

    context "when an Array is passed" do
      let(:array) { [[[1, 2], [1, 2]], [[3, 4], [3, 4]]] }
      let(:flat_array) { [1, 2, 1, 2, 3, 4, 3, 4] }

      it "returns a Tensor" do
        expect(described_class.from(array)).to eq(described_class.new(shape: [2, 2, 2], items: flat_array))
      end

      let(:misshaped_array) { [[[1, 2], [1, 2]], [[3, 4], [3, 4, 5]]] }

      it "fails if the array cannot be converted to a Tensor" do
        expect { described_class.from misshaped_array }.to raise_error(DimensionMismatch)
      end
    end
  end

  describe ".shape_of" do
    context "when a Tensor is passed" do
      let(:tensor) { described_class.zeros [2, 3, 4] }

      it "returns the shape of the Tensor" do
        expect(described_class.shape_of(tensor)).to eq([2, 3, 4])
      end
    end

    context "when a Numeric is passed" do
      it "returns 0, the shape of a Scalar" do
        expect(described_class.shape_of(10)).to eq(0)
      end
    end

    context "when an Array is passed" do
      let(:array) { [[[1, 2, 3], [1, 2, 3]], [[3, 4, 3], [3, 4, 3]]] }

      it "returns the shape of the nested arrays" do
        expect(described_class.shape_of(array)).to eq([2, 2, 3])
      end

      let(:misshaped_array) { [[[1, 2], [1, 2]], [[3, 4], [3, 4, 5]]] }

      it "raises an error when the array has no defined shape" do
        expect { described_class.shape_of misshaped_array }.to raise_error(DimensionMismatch)
      end
    end

    context "when the item passed cannot be converted to a Tensor" do
      it "raises an error" do
        expect { described_class.shape_of "Hello!"}.to raise_error(ArgumentError)
      end
    end
  end

  describe ".count_items_in_shape" do
    it "raises an error if the argument is not an Array" do
      expect { described_class.count_items_in_shape "Hello!" }.to raise_error(ArgumentError)
    end

    it "raises an error if the array contains non numeric items" do
      expect { described_class.count_items_in_shape [1, 2, "Hello!"] }.to raise_error(ArgumentError)
    end

    it "returns the amount of items that can be stored in the given array" do
      expect(described_class.count_items_in_shape([2, 3, 5])).to eq(30)
    end
  end
end
