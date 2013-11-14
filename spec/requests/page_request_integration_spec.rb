require 'spec_helper'

describe 'Page Requests' do
  after(:each) do
    Cmsimple::Page.destroy_all
  end

  let(:params) do
    {
      "authenticity_token"=>"R6xxyf0X6yknCFMCc3sMe4/8EY7bJq6WJj5iwOhka6c=",
      "page"=>{"title"=>"hello",
               "slug"=>"hello",
               "template"=>"",
               "parent_id"=>"",
               "is_root"=>"0",
               "browser_title"=>"",
               "keywords"=>"",
               "description"=>"" },
      "commit"=>"Create Page"
    }
  end

  context '#create' do
    it 'should create a page' do
      expect{ post '/pages', params }.to change {Cmsimple::Page.count}.by(1)
    end

    it 'should respond with success' do
      post '/pages', params
      expect(response.status).to eq(200)
    end
  end

  context '#update' do
    let!(:page) {Cmsimple::Page.create!(title: 'other page', slug: 'other_page')}
    it 'should update a page' do
      expect {
        put "/pages/#{page.id}", params, format: :js
      }.to change { page.reload.title }
      expect(response.status).to eq(200)
    end

    it 'should respond with success' do
      put "/pages/#{page.id}", params, format: :js
      expect(response.status).to eq(200)
    end
  end

  context '#update_content' do
    let!(:page) {Cmsimple::Page.create!(title: 'other page', slug: 'other_page')}
    let(:params) { {"content"=> {"heading"=> {"type"=>"full", "data"=>{}, "value"=>"Jed Jed", "snippets"=>{}}, "copy"=>{"type"=>"full", "data"=>{}, "value"=>"<p>Enter content or snippet</p>", "snippets"=>{}} }, "path"=>"other_page", "page"=>{ "content"=>{ "heading"=>{"type"=>"full", "data"=>{}, "value"=>"Jed Jed", "snippets"=>{}}, "copy"=>{"type"=>"full", "data"=>{}, "value"=>"<p>Enter content or snippet</p>", "snippets"=>{}}}}} }

    it 'updates content' do
      expect {
        put page.uri, params, format: :js
      }.to change { page.reload.content }
    end
  end
end
