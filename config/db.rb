require "active_record"

ActiveRecord::Base.logger = Logger.new(STDERR)
# ActiveRecord::Base.colorize_logging = false
ActiveRecord::Base.establish_connection host:'localhost', adapter:'sqlite3', encoding:'utf-8', database:'database.sqlite3'
# ActiveRecord::Schema.define do
#     create_table :users do |table|
#         table.string :email
#         table.string :password
#         table.integer :failed_attempts
# 		    table.datetime "created_at", null: false
# 		    table.datetime "updated_at", null: false
# 		    table.index ["email"], name: "index_admin_users_on_email", unique: true
#     end
# end

class User < ActiveRecord::Base
end
