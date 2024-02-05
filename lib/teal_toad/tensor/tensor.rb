# frozen_string_literal: true

module TealToad
  ##
  # Tensor class, contains both instance methods for Tensor and utility static methods.
  #
  class Tensor
    class << self
      def count_items_in_shape(shape)
        raise ArgumentError unless shape.is_a? Array
        raise ArgumentError unless shape.all? { |item_at_rank| item_at_rank.is_a? Numeric }

        shape.inject(1) { |acc, val| acc * val }
      end

      def shape_of(object)
        case object
        when Array
          shape_of_array object
        when Tensor
          object.shape
        when Numeric
          0
        else
          raise ArgumentError
        end
      end

      private

      def shape_of_array(array)
        if array.is_a?(Array)
          sub_shapes = array.map { |sub_arr| shape_of_array(sub_arr) }

          raise DimensionMismatch, "Subarrays must have consistent shapes" unless sub_shapes.uniq.size == 1

          [array.size] + sub_shapes.first
        else
          []
        end
      end
    end

    attr_reader :shape, :items

    def initialize(shape:, items:)
      @shape = shape
      @items = items
    end
  end
end
