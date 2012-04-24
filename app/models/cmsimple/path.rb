module Cmsimple
  class Path < ActiveRecord::Base
    attr_accessible :uri, :page_id, :redirect_uri

    belongs_to :page

    validates :uri, presence: true
    validates :uri, uniqueness: true

    validate :require_destination


    def self.from_request(request)
      path = request.is_a?(String) ? request : ( request.try(:path) || '' )
      path = "/#{path.gsub(/\/$/,'')}".gsub(/\/+/, '/')
      if path == '/'
        includes(:page).where('cmsimple_pages.is_root = ?', true).first!
      else
        includes(:page).where(uri: path).first!
      end
    end

    def destination
      @destination ||= if redirect?
                         Redirect.new(self)
                       else
                         self.page
                       end
    end

    def redirect?
      self.page.blank? || !(self.page.is_root || self.page.path == self.uri)
    end

    protected
    def require_destination
      unless destination.path.present?
        errors[:destination] << 'can\'t be blank'
      end
    end

    class Redirect
      def initialize(path)
        @path = path
      end

      def path
        @path.page.try(:path).presence || @path.redirect_uri
      end
    end
  end
end
