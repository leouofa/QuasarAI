module ApplicationHelper
  def menu_active?(test_path)
    return 'active' if request.path == test_path

    ''
  end
end
