class Transaction < ApplicationRecord
  belongs_to :account, required: false
  belongs_to :monthly_statistic, required: false
end
