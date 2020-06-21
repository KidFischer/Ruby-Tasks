Task1::App.controllers :items do

  get :index do
    #use item limit since result record count is large
    item_limit = 2000
    get_items(item_limit)
  end

  get :create do
    redirect "/items/create/10"
  end

  get :create, :with => :amount do
    amount = params[:amount].to_i
    amount = 10 if amount == 0

    table_name = create_temp_item_table
    insert_rows_to_temp_item_table(table_name, amount)
    #get_item_count_per_brand_code(table_name)
    table_name
  end
end
