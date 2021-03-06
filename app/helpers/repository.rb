class Repository
  def self.get_items(page, limit)
    Sequel::Model.db
        .fetch(get_items_join_with_parent_owner_brands(page, limit))
        .to_hash_groups(:code)

  end

  def self.get_item_count_per_brand_code(table_name)
    select_statement = "SELECT brand_code, COUNT(*) AS count FROM #{table_name} GROUP BY brand_code"
    Sequel::Model.db
        .fetch(select_statement)
  end

  def self.create_temp_item_table(table_name)
    Sequel::Model.db.create_table table_name do
      String :part_number, size:50, null: false
      String :name, size:500,  null: false
      String :brand_code, size:4, fixed: true, null: false
      index :part_number
      index :brand_code
    end
  end

  def self.insert_to_temp_item_table(table_name, fields, values)
    insert_statement = %[insert into #{table_name} (#{fields.join(", ")}) values('#{values.join("', '")}')]
    Sequel::Model.db[insert_statement].insert
  end

  private
  def self.get_items_join_with_parent_owner_brands(page, limit)
    offset = limit*(page-1)+1
    offset = 1 if offset < 1
    limit_setting = ""
    limit_setting = "limit #{offset}, #{limit}"

    "select c.* from(
      SELECT distinct
        b.code,
        a.part_number
      FROM
        items a
      inner JOIN
        parent_owner_brands b
      ON
        case when a.vmrs_brand_code IS not NULL then a.vmrs_brand_code ELSE a.parent_owner_brand_id END =
        case when a.vmrs_brand_code IS not NULL then b.code ELSE b.id end
      WHERE
        b.code not like '%T012%'
        #{limit_setting}) c
      order by c.code, c.part_number"
  end

end