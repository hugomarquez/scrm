class Crm::ContactDatatable < Core::Datatable
  delegate :params, :h, :link_to, :mail_to, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(
      Crm::Contact.number
      Core::Person.last_name
      Crm::Account.name
      Core::Person.email
      Crm::Contact.assistant
    )
  end

  def searchable_columns
    @searchable_columns ||= %w(
      Crm::Contact.number
      Core::Person.last_name
      Crm::Account.name
      Core::Person.email
      Core::Person.assistant
    )
  end

  def data
    records.map do |record|
      [
        link_to(record.number, record),
        link_to(record.person.full_name, record),
        account?(record),
        mail_to(record.person.email),
        record.person.assistant,
      ]
    end
  end

  def account?(record)
    record.account ? link_to(record.account.name, record.account) : ""
  end

  def get_raw_records
    Crm::Contact.includes(:person, :account).references(:person).distinct
  end
end
