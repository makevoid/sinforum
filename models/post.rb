class Post
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, length: 100
  property :text,       Text, required: true
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :forum
  belongs_to :user
  alias :author :user

  validates_presence_of :title, :if => lambda { |p| p.parent_id.nil? }

  # scopes

  def self.by_update
    all order: :updated_at.desc
  end

  def self.roots
    all parent_id: nil
  end

  # parent

  property :parent_id, Integer

  def root?
    parent_id.nil?
  end

  def parent
    parent_id ? Post.get(parent_id) : self
  end

  def children
    Post.all parent_id: self.id
  end
  alias :replies :children

  private

  # timestamps at

  before :create do
    self.created_at = Time.now
  end

  before :save do
    self.updated_at = Time.now
  end

  after :save do
    attrs = { updated_at: Time.now }
    if root?
      attrs.merge! last_post_id: self.id, posts_count: forum.posts_count+1
    else
      parent.update attrs
    end
    forum.update attrs
  end

  after :destroy do
    forum.update last_post_id: nil, posts_count: forum.posts_count-1 if root?
  end

end