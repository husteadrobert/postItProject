module Slugable
  extend ActiveSupport::Concern
    
  included do
    after_validation :generate_slug
    class_attribute :slug_column
  end

  def to_param
    self.slug
  end

  def generate_slug
    # the_slug = create_slug(self.title) if self.class.name == "Post"
    # the_slug = create_slug(self.name) if self.class.name == "Category"
    # the_slug = create_slug(self.username) if self.class.name == "User"

    the_slug = create_slug(self.send(self.class.slug_column.to_sym))

    record = self.class.find_by(slug: the_slug)
    count = 2
    while record && record != self
      the_slug = append_suffix(the_slug, count)
      record = self.class.find_by(slug: the_slug)
      count += 1
    end
    self.slug = the_slug
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      return str.split('-').slice(0...-1).join('-') + "-" + count.to_s
    else
      return str + "-" + count.to_s
    end
  end

  def create_slug(name)
    str = name.strip
    str.gsub!(/\s*[^A-Za-z0-9]\s*/, '-')
    str.gsub!(/-+/, '-')
    str.downcase
  end

  module ClassMethods
    def set_slugable_column(name)
      self.slug_column = name
    end
  end

end