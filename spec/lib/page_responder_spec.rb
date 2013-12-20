require 'spec_helper'

describe Cmsimple::PageResponder do
  let(:controller) { OpenStruct.new request: OpenStruct.new(params: @params || {}),
                                    current_page: @page,
                                    in_editor_iframe?: @editable }

  it 'raises ActiveRecord::RecordnotFound if the page is not viewable' do
    responder = Cmsimple::PageResponder.new(controller)
    responder.should_receive(:current_page_is_viewable?).and_return(false)
    expect { responder.respond }.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'current page is viewable' do
    let(:responder) { responder = Cmsimple::PageResponder.new(controller) }
    it 'is viewable if the request is in the editor iframe' do
      @editable = true
      responder.current_page_is_viewable?.should be_true
    end

    it 'is viewable if the page is published' do
      @editable = false
      @page = double('page', :published? => true)
      responder.current_page_is_viewable?.should be_true
    end

    it 'is not viewable if the request is not the editor iframe and the page is not published' do
      @editable = false
      @page = double('page', :published? => false)
      responder.current_page_is_viewable?.should be_false
    end
  end

  describe 'page for context' do
    let(:responder) { responder = Cmsimple::PageResponder.new(controller) }
    it 'tries to use the published version of the page if the app is not in edit mode' do
      @editable = false
      @page = double('page', :published? => true)
      @page.should_receive(:as_published!).and_return(true)
      responder.page_for_context
    end

    it 'tries to use the published version of the page if the app is not in edit mode' do
      @editable = true
      @page = double('page', :published? => true)
      @params = {version: 1}
      @page.should_receive(:at_version!).and_return(true)
      responder.page_for_context
    end

    it 'uses the current draft version by default' do
      @editable = true
      @page = double('page', :published? => false)
      responder.should_receive(:draft_context?)
      responder.page_for_context
    end
  end
end
