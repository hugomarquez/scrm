class Crm::LeadLookup < Core::Datatable
  delegate :params, :h, :link_to, :check_box, :number_to_currency, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(
      Crm::Lead.number
      Core::Person.first_name
      Core::Person.last_name
      Crm::Lead.company
    )
  end

  def searchable_columns
    @searchable_columns ||= %w(
      Crm::Lead.number
      Core::Person.first_name
      Core::Person.last_name
      Crm::Lead.company
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
          record.person.full_name,
          'javascript:void(0)',
          onclick:"lookup.start(this)",
          data:{resource: record.id, label: record.person.full_name}
        ),
        link_to(
          record.company,
          'javascript:void(0)',
          onclick:"lookup.start(this)",
          data:{resource: record.id, label: record.company}
        )
      ]
    end
  end

  def get_raw_records
    Crm::Lead.includes(:person).references(:person).distinct
  end
end
