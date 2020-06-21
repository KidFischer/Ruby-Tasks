class Repository
  def self.get_items(limit)
    Sequel::Model.db
        .fetch(get_items_join_with_parent_owner_brands(limit))
        .to_hash_groups(:code)
  end

  def self.create_temp_item_table(table_name)
    Sequel::Model.db.create_table table_name do
      String :part_number, size:50, null: false
      String :name, size:500,  null: false
      String :brand_code, size:4, fixed: true, null: false
      index :part_number, unique:true
      index :brand_code, unique:true
    end
  end

  def self.insert_to_temp_item_table(table_name, fields, values)
    insert_statement = %[insert into #{table_name} (#{fields.join(", ")}) values('#{values.join("', '")}')]
    Sequel::Model.db[insert_statement].insert
  end

  private
  def self.get_items_join_with_parent_owner_brands(limit = -1)
    limit_setting = ""
    limit_setting = "limit #{limit}" if limit > -1

    "SELECT c.* from

      (SELECT
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
      GROUP BY
        c.part_number,
        c.code
      order BY
        CODE, part_number
    "
  end

end