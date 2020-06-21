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

      def create_temp_item_table
        table_name = generate_table_name_with_prefix("temp_item")
        Repository.create_temp_item_table(table_name)
        table_name
      end

      def insert_rows_to_temp_item_table(table_name, amount)
        fields = ["part_number","name","brand_code"]
        amount.times do
          values = generate_temp_item_values
          Repository.insert_to_temp_item_table(table_name, fields, values)
        end
      end

      def get_item_count_per_brand_code(table_name)
        12
      end

      private
      def generate_temp_item_values
        part_number = generate_code(rand(25..50))
        name = generate_code(rand(250..500))
        brand_code = generate_code(4,{no_digit:true})
        [part_number, name, brand_code]
      end

      def generate_table_name_with_prefix(table_name_prefix)
        timestamp = Integer(1e3*Time.now.to_f)
        random_key = generate_code(6,{no_digit: true})
        "#{table_name_prefix}_#{timestamp}_#{random_key}"
      end

      def generate_code(char_count, options = {})
        charset = []
        charset = Array('A'..'Z') + Array('a'..'z')  unless options[:no_alpha]
        charset = charset + Array('0'..'9') unless options[:no_digit]
        Array.new(char_count) { charset.sample }.join
      end

      def add_highlight(dataset)
        dataset.map do |code,part_numbers|
          new_part_numbers = []
          part_numbers.each_with_index do |item,index|
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
