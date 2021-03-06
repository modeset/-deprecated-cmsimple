module Cmsimple
  class Path < ActiveRecord::Base

    belongs_to :page

    validates :uri, presence: true,
                    uniqueness: true

    validate :require_destination

    before_validation :downcase_uri

    def self.from_request(request)
      if !request.params.has_key?(:path)
        with_pages.merge(Cmsimple::Page.root).first
      elsif result = find_from_request(request)
        result
      end
    end

    def self.from_uri(uri)
      with_pages.where(uri: uri.downcase).first
    end

    def self.from_request!(request)
      from_request(request) || raise(ActiveRecord::RecordNotFound.new)
    end

    def self.with_pages
      includes(:page).references(:pages)
    end

    def destination
      @destination ||= if redirect?
                         Redirect.new(self)
                       else
                         self.page
                       end
    end

    def redirect?
      self.page.blank? || !(self.page.is_root || self.page.uri == self.uri)
    end

    protected

    def self.find_from_request(request)
      if found_with_fullpath = from_uri(request.fullpath)
        found_with_fullpath
      else
        path = request.params[:path]
        path = "/#{path.gsub(/\/$/,'')}".gsub(/\/+/, '/')
        from_uri(path)
      end
    end

    def require_destination
      unless destination.uri.present?
        errors[:destination] << 'can\'t be blank'
      end
    end

    def downcase_uri
      self.uri.downcase! if self.uri.present?
    end

    class Redirect
      def initialize(path)
        @path = path
      end

      def uri
        @path.page.try(:uri).presence || @path.redirect_uri
      end
    end
  end
end
