
require 'json'

class Item
  def initialize(part_number,highlight)
    @part_number = part_number
    @highlight = highlight
  end

  attr_accessor :highlight, :part_number

  def as_json(options={})
    {
        part_number: @part_number,
        highlight: @highlight
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end