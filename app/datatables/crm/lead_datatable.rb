class Crm::LeadDatatable < Core::Datatable
  delegate :params, :h, :link_to, :check_box, :number_to_currency, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(
      Crm::Lead.number
      Crm::Lead.company
      Core::Person.first_name
      Core::Person.last_name
      Core::Person.email
      Crm::Lead.status
    )
  end

  def searchable_columns
    @searchable_columns ||= %w(
      Crm::Lead.number
      Crm::Lead.company
      Core::Person.first_name
      Core::Person.last_name
      Core::Person.email
      Crm::Lead.status
    )
  end

  def data
    records.map do |record|
      [
        link_to(record.number, record),
        link_to(record.company, record),
        record.person.first_name,
        record.person.email,
        I18n.t("activerecord.attributes.crm/lead.statuses_options.#{record.status}"),
      ]
    end
  end

  def get_raw_records
    Crm::Lead.includes(:person).references(:person).distinct
  end
end
