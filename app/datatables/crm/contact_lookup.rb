class Crm::ContactLookup < Core::Datatable
  delegate :params, :h, :link_to, :check_box, :number_to_currency, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(
      Crm::Contact.number
      Core::Person.email
    )
  end

  def searchable_columns
    @searchable_columns ||= %w(
      Crm::Contact.number
      Core::Person.email
    )
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
          record.person.email,
          'javascript:void(0)',
          onclick:"lookup.start(this)",
          data:{resource: record.id, label: record.person.email}
        )
      ]
    end
  end

  def get_raw_records
    Crm::Contact.includes(:person).references(:person).distinct
  end
end
