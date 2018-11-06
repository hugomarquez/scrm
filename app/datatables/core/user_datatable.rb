class Core::UserDatatable < Core::Datatable
  delegate :params, :h, :link_to, :check_box, :number_to_currency, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(Core::User.email)
  end

  def searchable_columns
    @searchable_columns ||= %w(Core::User.email)
  end

  def data
    records.map do |record|
      [
        link_to(record.email, record),
      ]
    end
  end

  def get_raw_records
    Core::User
  end

end
