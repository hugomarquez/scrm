class Crm::DealDatatable < Core::Datatable
  delegate :params, :h, :link_to, :check_box, :number_to_currency, to: :@view

  def sortable_columns
    @sortable_columns ||= %w(
      Crm::Deal.number
      Crm::Deal.name
      Crm::Deal.stage
      Crm::Deal.amount
    )
  end

  def searchable_columns
    @searchable_columns ||= %w(
      Crm::Deal.number
      Crm::Deal.name
      Crm::Deal.stage
      Crm::Deal.amount
    )
  end

  def data
    records.map do |record|
      [
        link_to(record.number, record),
        link_to(record.name, record),
        I18n.t("activerecord.attributes.crm/deal.stages_options.#{record.stage}"),
        number_to_currency(record.amount)
      ]
    end
  end

  def get_raw_records
    Crm::Deal
  end
end
