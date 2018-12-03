class Crm::AccountLookup < Core::Datatable

  def sortable_columns
    @sortable_columns ||= %w(Crm::Account.number Crm::Account.name Crm::Account.email)
  end

  def searchable_columns
    @searchable_columns ||= %w(Crm::Account.number Crm::Account.name Crm::Account.email)
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
        ),
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
    Crm::Account
  end

end
