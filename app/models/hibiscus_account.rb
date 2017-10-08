class HibiscusAccount < ApplicationRecord
  establish_connection(:external_hibiscus)
  self.table_name = 'hibiscus.konto'
end
