require 'sequel'

Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = case Padrino.env
  when :development then Sequel.connect(:adapter => 'mysql2', :user => 'jimmy', :host => 'localhost', port:3306, :database => 'philipp_db',:password=>'Password-123')
  when :production  then Sequel.connect(:adapter => 'mysql2', :user => 'jimmy', :host => 'localhost', port:3306, :database => 'philipp_db',:password=>'Password-123')
  when :test        then Sequel.connect(:adapter => 'mysql2', :user => 'jimmy', :host => 'localhost', port:3306, :database => 'philipp_db',:password=>'Password-123')
end
