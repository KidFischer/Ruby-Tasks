Task1::App.controllers :items do
  get :index do
    redirect "/items/1/1000"
  end

  get :index, :with => [:page_num, :item_limit] do
    page_num = params[:page_num].to_i
    page_num = 1 if page_num < 1
    item_limit = params[:item_limit].to_i
    item_limit = 1000 if item_limit == 0

    get_items(page_num, item_limit)
  end
end
