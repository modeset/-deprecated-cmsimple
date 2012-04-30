module Cmsimple
  class Page < ActiveRecord::Base
    serialize :content, Hash

    attr_accessible :path,
                    :slug,
                    :title,
                    :content,
                    :template,
                    :parent_id,
                    :is_root,
                    :position,
                    :published,
                    :keywords,
                    :description,
                    :browser_title

    belongs_to :parent,   :class_name => '::Cmsimple::Page', :foreign_key => 'parent_id'
    has_many   :children, :class_name => '::Cmsimple::Page', :foreign_key => 'parent_id', :dependent => :destroy
    has_many   :paths,    :dependent => :destroy
    has_many   :versions, :dependent => :destroy

    validates :path,
              :slug,
              :title,
              :presence => true

    validates :path, :uniqueness => true

    validate :is_root_set

    before_validation :set_internal_path
    before_save :ensure_only_one_root
    after_save  :create_path

    def self.for_parent_select(page)
      scope = scoped
      unless page.new_record?
        scope = scope.where('id NOT IN (?)', page.descendants.map(&:id) + [page.id])
      end
      scope.all
    end

    def self.root
      where('cmsimple_pages.is_root = ?', true).limit(1)
    end

    def self.published
      where('cmsimple_pages.published_at <= ?', Time.zone.now.utc)
    end

    def self.unpublished
      where('cmsimple_pages.published_at IS NULL')
    end

    def root
      parent = self.parent || self
      while parent.try(:parent)
        parent = parent.parent
      end
      parent
    end

    def descendants
      children.all.inject([]) do |ary, child|
        ary << child
        ary + child.descendants
      end.sort_by(&:position)
    end

    def regions
      @regions ||= RegionsProxy.new(self.content)
    end

    def update_content(content)
      update_attributes(content: content)
    end

    def slug
      self[:slug] ||= escape(title)
    end

    def slug=(val)
      self[:slug] = escape(val)
    end

    # override in app to set optional rendering parameters like layouts
    # on a per page basis
    def template_render_options
      Cmsimple.configuration.template_render_options
    end

    def publish!
      self.published_at = Time.zone.now
      self.save!
      create_new_version
    end

    def unpublish!
      self.published_at = nil
      self.save!
    end

    def published?
      self.published_at.present? && self.published_at <= Time.zone.now
    end

    def published=(val)
      if val.to_bool
        self.publish!
      else
        self.unpublish!
      end
    end

    protected

    def escape(string)
      result = string.to_s.dup
      result.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      result.gsub!(/[^\w_ \-]+/i, '') # Remove unwanted chars.
      result.gsub!(/[ \-]+/i, '-') # No more than one of the separator in a row.
      result.gsub!(/^\-|\-$/i, '') # Remove leading/trailing separator.
      result.downcase
    end

    def set_internal_path
      self.path = [self.parent.try(:path), slug].join('/')
    end

    def ensure_only_one_root
      if is_root_changed? && is_root?
        self.class.where(is_root: true).update_all(is_root: false)
      end
    end

    def is_root_set
      if is_root_changed? && !is_root?
        errors[:is_root] << "can't unset home page"
      end
    end

    def create_path
      associated_path = Cmsimple::Path.where(uri: self.path).first_or_initialize
      associated_path.page = self
      associated_path.redirect_uri = nil
      associated_path.save!
    end

    def create_new_version
      self.versions.create! content: self.content, template: self.template, published_at: self.published_at
    end

  end
end
