class Quote < ApplicationRecord
  belongs_to :company

  validates :name, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  # Basic syntax for after commit callbacks with broadcasting:
  # after_create_commit { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }
  # after_update_commit { broadcast_replace_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quote_#{self.id}" }
  # after_destroy_commit { broadcast_remove_to "quotes", target: "quote_#{self.id}" }

  # Shorter syntax for after commit callbacks with broadcasting:
  # after_create_commit { broadcast_prepend_to "quotes" }
  # after_update_commit { broadcast_replace_to "quotes" }
  # after_destroy_commit { broadcast_remove_to "quotes" }

  # Broadcasting asynchronous with ActiveJob
  # after_create_commit { broadcast_prepend_later_to "quotes" }
  # after_update_commit { broadcast_replace_later_to "quotes" }
  # after_destroy_commit { broadcast_remove_to "quotes" }

  # The three callbacks are equivalent to a single line of code
  broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend
end
