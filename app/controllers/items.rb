Task1::App.controllers :items do
  get :create do
    redirect "/items/create/10"
  end

  get :create, :with => :amount do
    amount = params[:amount].to_i
    amount = 10 if amount == 0

    table_name = create_temp_item_table
    insert_rows_to_temp_item_table(table_name, amount)
    get_brand_code_count(table_name)
  end

  get :index do
    redirect "/items/1000"
  end

  get :index, :with => :item_limit do
    item_limit = params[:item_limit].to_i
    item_limit = 1000 if item_limit == 0

    #TODO: use paging instead of return huge chunk to client
    get_items(item_limit)
  end
end
