module ApplicationHelper
  def bootstrap_class_for flash_type
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
      }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message
            end)
    end
    nil
  end

  def link_to_remove_search_field(type)
    link_to "remove", '#', class: "remove_#{type}"
  end

  def link_to_add_search_field(f, type)
    new_object, name = f.object.send("build_#{type}"), "#{type}_fields"
    id = "new_#{type}"

    fields = f.send(name, new_object, child_index: id) do |builder|
      render("search/#{name}", f: builder)
    end

    link_to("Add #{type.to_s.titleize}", '#', class: "add_#{type}", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
