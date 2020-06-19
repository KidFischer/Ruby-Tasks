# Helper methods defined here can be accessed in any controller or view in the application
require_relative 'repository'
require_relative '../entities/item'
module Task1
  class App
    module ItemsHelper

      def get_items(limit)
        dataset = Repository.get_items(limit)
        dataset = add_highlight(dataset)
        dataset.to_json
      end

      def add_highlight(dataset)
        dataset.map do |code,part_numbers|
          new_part_numbers = []
          part_numbers.each_with_index do |item,index|
            p item, index
            new_part_numbers.push(Item.new(item[:part_number], can_highlight(part_numbers,index)))
          end
          {code => new_part_numbers}
        end
      end

      def can_highlight(items, index)
        next_index = index + 1
        return false unless items[next_index]

        current_part_number_last_digit = items[index][:part_number][-1].to_i
        next_part_number_last_digit = items[next_index][:part_number][-1].to_i

        (next_part_number_last_digit - current_part_number_last_digit) == 1
      end
    end
    helpers ItemsHelper
  end
end
