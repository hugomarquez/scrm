class Core::UserLookup < Core::Datatable

  def sortable_columns
    @sortable_columns ||= %w(Core::User.email)
  end

  def searchable_columns
    @searchable_columns ||= %w(Core::User.email)
  end

  def data
    records.map do |record|
      [
        link_to(
          record.email,
          'javascript:void(0)',
          onclick:"lookup.start(this)",
          data:{resource: record.id, label: record.email}
        )
      ]
    end
  end

  def get_raw_records
    Core::User.includes(:person).references(:person).distinct
  end

end
