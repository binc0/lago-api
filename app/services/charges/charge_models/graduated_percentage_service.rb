# frozen_string_literal: true

module Charges
  module ChargeModels
    class GraduatedPercentageService < Charges::ChargeModels::BaseService
      protected

      def ranges
        properties['graduated_percentage_ranges']&.map(&:with_indifferent_access)
      end

      def compute_amount
        ranges.reduce(0) do |result_amount, range|
          flat_amount = BigDecimal(range[:flat_amount])
          fixed_amount = BigDecimal(range[:fixed_amount])
          rate = BigDecimal(range[:rate])

          # NOTE: Add flat amount to the total
          result_amount += flat_amount unless units.zero?

          # NOTE: Apply rate to the range units
          range_units = compute_range_units(range[:from_value], range[:to_value])
          result_amount += (range_units * rate).fdiv(100)

          # NOTE: units is between the bounds of the current range,
          #       we must stop the loop
          if range[:to_value].nil? || range[:to_value] >= units
            # NOTE: Add fixed amount per event
            break result_amount + aggregation_result.count * fixed_amount
          end

          result_amount
        end
      end

      # NOTE: compute how many units to bill in the range
      def compute_range_units(from_value, to_value)
        # NOTE: units is higher than the to_value of the range
        if to_value && units >= to_value
          return to_value - (from_value.zero? ? 1 : from_value) + 1
        end

        return to_value - from_value if to_value && units >= to_value
        return units if from_value.zero?

        # NOTE: units is in the range
        units - from_value + 1
      end
    end
  end
end
