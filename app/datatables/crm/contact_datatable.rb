class Crm::ContactDatatable < Core::Datatable
  delegate :params, :h, :link_to, :check_box, :number_to_currency, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(
      Crm::Contact.number
      Core::Person.first_name
      Core::Person.last_name
      Core::Person.email
    )
  end

  def searchable_columns
    @searchable_columns ||= %w(
      Crm::Contact.number
      Core::Person.first_name
      Core::Person.last_name
      Core::Person.email
    )
  end

  def data
    records.map do |record|
      [
        link_to(record.number, record),
        link_to(record.person.first_name, record),
        link_to(record.person.last_name, record),
        link_to(record.person.email, record)
      ]
    end
  end

  def get_raw_records
    Crm::Contact.includes(:person).references(:person).distinct
  end
end
