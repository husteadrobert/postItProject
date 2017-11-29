class Category < ActiveRecord::Base
  include Slugable

  has_many :post_categories
  has_many :posts, through: :post_categories

  #after_validation :generate_slug

  validates :name, presence: true

  set_slugable_column :name
  # def generate_slug
  #   the_slug = create_slug(self.name)
  #   post = Category.find_by(slug: the_slug)
  #   count = 2
  #   while post && post != self
  #     the_slug = append_suffix(the_slug, count)
  #     post = Category.find_by(slug: the_slug)
  #     count += 1
  #   end
  #   self.slug = the_slug
  # end

  # def append_suffix(str, count)
  #   if str.split('-').last.to_i != 0
  #     return str.split('-').slice(0...-1).join('-') + "-" + count.to_s
  #   else
  #     return str + "-" + count.to_s
  #   end
  # end

  # def create_slug(name)
  #   str = name.strip
  #   str.gsub!(/\s*[^A-Za-z0-9]\s*/, '-')
  #   str.gsub!(/-+/, '-')
  #   str.downcase
  # end

  # def to_param
  #   self.slug
  # end
  
end