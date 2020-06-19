Task1::App.controllers :items do

  get :index do

    #use item limit since result record count is large (TODO: use paging technique)
    item_limit = 2000
    get_items(item_limit)
  end

end
