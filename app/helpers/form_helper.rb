module FormHelper

  def errors_for(form, field)
    content_tag(:p, form.object.errors[field].try(:first), class: 'col-sm-offset-6 col-sm-6 help-block')
  end

  def form_group_for(form, field, opts={}, &block)
    label = opts.fetch(:label){true}
    has_errors = form.object.errors[field].present?
    content_tag :div, class: "form-group #{'has-error' if has_errors} #{'required' if required?(form, field)}" do
      concat form.label(field, class: 'col-sm-4 form-control-label') if label
      concat capture(&block)
      concat errors_for(form, field)
    end
  end

  def form_disabled(f, attr)
    json_object = f.object.safe_params.to_json
    json_object.exclude? attr.to_s
  end

  def required?(f, field)
    target = (f.object.class == Class) ? f.object : f.object.class
    target.validators_on(field).map(&:class)
      .include?(ActiveRecord::Validations::PresenceValidator)
  end

  def link_to_add_fields(label, f, association, opts={})
    path = opts.fetch(:path){''}
    style = opts.fetch(:class){''}

    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(path + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(label, 'javascript:void(0)', class: "add_fields #{style}", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def options_for_t_enum(form, field)
    klass = form.object.class
    enum = field.to_s.pluralize.to_sym
    form.select(
      field,
      klass.send(enum).collect{|s| [ t_enum(klass,enum,{value: s[0]}), s[0] ]},
      {},
      class: 'form-control'
    )
  end

  def t_enum(klass, enum, options={})
    unless options[:value]
      klass.send(enum).keys.map do |k|
        I18n.t("activerecord.attributes.#{klass.model_name.i18n_key}.#{enum.to_s.pluralize}_options.#{k}")
      end
    else
      I18n.t("activerecord.attributes.#{klass.model_name.i18n_key}.#{enum.to_s.pluralize}_options.#{options[:value]}")
    end
  end

end
