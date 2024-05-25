module ApplicationHelper
  def add_page_title(content)
    @page_title ||= ['Ajuda Humanitária']
    @page_title.push(content)
  end

  def page_title
    @page_title ||= []
    @page_title.reverse.join(' | ')
  end
end
