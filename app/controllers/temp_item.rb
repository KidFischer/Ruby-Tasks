Task1::App.controllers 'temp-item' do

  get :index do
    "
    <pre>
    '/temp-item/read'      #to view generated records
    '/temp-item/create'   #to create item_temp table
    '/temp-item/insert'   #to insert records with a new brand_code
    </pre>
    "
  end

  get :read do
    table_name = session[:temp_item_table_name]
    return "Temp item table required. Please create temp table" unless table_name
    get_brand_code_count(table_name)
  end

  get :create do
    amount = params[:amount].to_i
    amount = 10 if amount == 0

    session[:temp_item_table_name] = create_temp_item_table
    "temp item table name: #{session[:temp_item_table_name]}"
  end

  get :insert, :with => :amount do
    amount = params[:amount].to_i
    amount = 10 if amount == 0

    table_name = session[:temp_item_table_name]
    insert_rows_to_temp_item_table(table_name, amount)
    redirect "/temp-item/read"
  end
end
