class Crm::AccountDatatable < Core::Datatable
  delegate :params, :h, :link_to, :mail_to, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(
      Crm::Account.number
      Crm::Account.name
      Crm::Account.email
      Crm::Account.phone
      Crm::Account.website
    )
  end

  def searchable_columns
    @searchable_columns ||= %w(
      Crm::Account.number
      Crm::Account.name
      Crm::Account.email
      Crm::Account.phone
      Crm::Account.website
    )
  end

  def data
    records.map do |record|
      [
        link_to(record.number, record),
        link_to(record.name, record),
        mail_to(record.email),
        record.phone,
        link_to(record.website, record.website, target: :_blank),
      ]
    end
  end

  def get_raw_records
    Crm::Account
  end

end
