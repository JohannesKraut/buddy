class HibiscusTransaction < ApplicationRecord
  establish_connection(:external_hibiscus)
  self.table_name = 'hibiscus.umsatz'
end
