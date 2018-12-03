json.array! @tasks do |task|
  date_format = task.all_day ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'

  json.id     task.id
  json.title  task.subject
  json.start  task.starts_at.strftime(date_format)
  json.end    task.ends_at.strftime(date_format)
  json.url    edit_core_task_path(task)
  json.color  task.color unless task.color.blank?
  json.allDay task.all_day
end
