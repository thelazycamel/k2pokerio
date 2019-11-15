require Protocol

Protocol.derive(Jason.Encoder, Scrivener.Page, only: [:entries, :page_number, :total_pages, :total_entries, :page_size])

