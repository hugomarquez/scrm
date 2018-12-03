module LookupHelper

  def select_for_lookup(form, field, options={})
    klass = form.object.class
    id = options[:id].blank? ? 'polymorphic_select' : options[:id]
    form.select(
      field,
      t_models.collect{|s| [s[1][:one], s[0].to_s.classify ] },
      {},
      class:'form-control',
      id: id
    )
  end

  def t_models
    I18n.t("activerecord.models").select do |a|
      a.to_s.match(/^crm/) and
      a.to_s.exclude?('crm/task')
    end
  end

  def polymorphic_link_to(model)
    case model.class.to_s
    when 'Crm::Account'
      link_to model.name, model
    when 'Crm::Contact'
      link_to model.person.full_name, model
    when 'Crm::Lead'
      link_to model.company, model
    end
  end

  def model_datatable(route, fields, id)
    content_tag(
      :table,
      class:'table table-striped ajax-data-table',
      width:'100%',
      id: id,
      data: { source: route, email: current_core_user.email, token: current_core_user.authentication_token }
    ) do
      data_table(fields)
    end
  end

  def data_table(fields)
    content_tag :thead do
      content_tag :tr do
        fields.each do |f|
          concat content_tag :th, f
        end
      end
    end
  end

  def modal(title, route, fields, id, input, label, datatable_id)
    content_tag(:div, class:'modal fade',id: id, role:'dialog', tabindex: -1, data:{input:input, label: label}) do
      content_tag :div, class:'modal-dialog modal-lg', role:'document' do
        content_tag :div, class:'modal-content' do
          concat(modal_header(title))
          concat(modal_body(route, fields, datatable_id))
          concat(modal_footer)
        end
      end
    end
  end

  def modal_header(title)
    content_tag :div, class:'modal-header' do
      content_tag(:button, class:'close', "aria-label": "Close", "data-dismiss": "modal", type: "button") do
        content_tag :span do
          '×'
        end
      end
      .concat content_tag(:h4, title, class:'modal-title')
    end
  end

  def modal_body(route, fields, id)
    content_tag :div, class:'modal-body table-responsive' do
      model_datatable(route, fields, id)
    end
  end

  def modal_footer
    content_tag :div, class:'modal-footer'  do
      content_tag :button, t('views.shared.cancel'), class:'btn btn-default', 'data-dismiss': 'modal', type:'button'
    end
  end

end
