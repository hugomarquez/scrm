class Crm::AccountLookup < Core::Datatable

  def sortable_columns
    @sortable_columns ||= %w(Crm::Account.number Crm::Account.name)
  end

  def searchable_columns
    @searchable_columns ||= %w(Crm::Account.number Crm::Account.name)
  end

  def data
    records.map do |record|
      [
        link_to(
          record.number,
          'javascript:void(0)',
          onclick:"lookup.start(this)",
          data:{resource: record.id, label: record.number}
        ),
        link_to(
          record.name,
          'javascript:void(0)',
          onclick:"lookup.start(this)",
          data:{resource: record.id, label: record.name}
        )
      ]
    end
  end

  def get_raw_records
    Crm::Account
  end

end
