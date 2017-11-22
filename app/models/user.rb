class User < ActiveRecord::Base
  has_many :posts, foreign_key: :user_id
  has_many :comments, foreign_key: :user_id
  has_many :votes

  has_secure_password validations: false

  after_validation :generate_slug

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 3}, on: :create

  def generate_slug
    the_slug = create_slug(self.username)
    post = Post.find_by(slug: the_slug)
    count = 2
    while post && post != self
      the_slug = append_suffix(the_slug, count)
      post = Post.find_by(slug: the_slug)
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

  def to_param
    self.slug
  end
  
end