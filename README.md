# CMSimple

[![Build Status](https://secure.travis-ci.org/modeset/cmsimple.png?branch=master)](http://travis-ci.org/modeset/cmsimple)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/modeset/cmsimple)
[![Gem Version](https://badge.fury.io/rb/cmsimple.png)](http://badge.fury.io/rb/cmsimple)

CMSimple is an easy-to-use but extensible CMS wrapped around the Mercury editor (https://github.com/jejacks0n/mercury), written as a Rails engine.

## Rails 4 Ready

Master branch is for Rails 4.0+

## Rails 3

A stable version of the project is available on the branch `rails3-stable`. Rails 3 projects should point to that tag in their Gemfile.

## Getting Started

Add the gem to your Gemfile

```ruby
gem 'cmsimple', github: 'modeset/cmsimple'
```

Run the install generator

```shell
rails g cmsimple:install
```

## Templates

CMSimple templates are just views. They get rendered from the Cmsimple::FrontController inside the CMSimple engine. The core of a view is the render_region helper which indicates where in the dom a region is rendered and which region to render. There are two ways to invoke the region. The first is by just telling it what region you want to render. With this method you still have to tell Mercury how to find and associate the region. Below is an example:

```erb
<h1 id='page_title' class="page-heading" data-mercury='full'>
  <%= render_region :page_title do %>
    Placeholder
  <% end %>
</h1>
```

Above we are using an h1 as the region container for our content. And we are telling Mercury to use a "full" region. Please note that the id of the element must match the region name passed into the helper in this use case as the id is how Mercury references regions.

You can also tell the helper to render the container by providing the tag: :element argument in the options hash. The options hash also takes the region type (:full, :snippets, :simple are supported) and an html option which gets handed to the content_tag helper so you can provide options for building out the content_tag container.

```erb
<%= render_region :aside_navigation, region_type: :snippets, tag: :div, html: {class: 'aside'} do %>
<% end %>
```

Templates are located in the app/views/cmsimple/templates directory. Below is an example of what the cmsimple views directory might look like for a simple site.

```
app/views/cmsimple/
├── _snippet_list.html.haml
├── pages
│   └── _form_extras.html.haml
└── templates
    ├── generic.html.haml
    ├── home-v1.html.haml
    ├── one-column.html.haml
    └── two-column.html.haml

```
### Notes

There are a couple of things to keep in mind as you maintain and augment templates. The first is that you should try to keep regions consistently named. If a user changes the template that they want to use if the regions are not named the same the content will not display in the new template. Of course this isn't always possible, for example the home page template is very different from any of the content templates.

Another item to note about this behavior is that if a user switches a template in draft mode and saves the content, if they attempt to revert back to the previous template they may permanently loose content in regions where the names are not available between templates. This is not the case if a user has published a page as they can then just revert to a previous version of the page to regain the content.

Regions must always be contained by block level elements (i.e. the tag: :div declaration). This is actually a limitation of the browser. A specifically onerous element is the &lt;p&gt; tag. Since the W3C spec indicates that no block level elements can be children of the &lt;p&gt; tag, the browser will attempt to correct the content by moving it outside the tag. This results in a lot of confusion and strange looking rendered content.

## Snippets

[Cells](https://github.com/apotonick/cells) are how CMSimple implement Mercury's idea of snippets. Snippets are meant to be a way for authors to be able to utilize content that requires more complicated html to render. In general authors don't want to learn html, but often a design for a template can require a very specific html markup with associated classes in order for the css to be able to layout the page properly. Snippets provide this framework.

Snippets have 3 required parts in order to provide basic functionality, the *_cell.rb Cell class (which is essentially like a mini controller), the display view and the options view

* The cell class has three "actions", or states as cells calls them, display, preview, and options. Display is used to render the snippet into the template. Preview is used when a new snippet is added to a region via Mercury. It makes an ajax request for the preview so that the author can see the snippet in real time. 99% of the time preview just calls through to display. Options is where we create the form where the author will provide the content for a snippet.

* The display view is just a normal rails view where you render your snippet. The best practice is to map all of the snippet options as instance variables in your action so that the view doesn't need to refer to a snippet. This allows easy updating and keeps the views simple.

* The options view is where you create your form for telling Mercury what options are to be persisted for a given snippet. It is important to note that Mercury will only save options that exist in the form (more on this later). We are currently using Formtastic to create all the forms in this project.

### Snippet options

Snippet options are the most complex part of a snippet. This stems from trying to understand how Mercury serializes snippets and how they get re-rendered. Essentially Mercury can only persist what is in an options form. This means that _any_ data that needs to be captured and maintained throughout a snippets life must have an input in the form.

* Changing the wrapper element of a snippet
    
    In order to change the wrapper tag (it defaults to a div) you need to provide a hidden input into the options form called "wrapperTag".

    ```erb
    <%= hidden_field_tag :wrapperTag, 'li' %>
    ```
    The above sets the wrapper tag to be an li instead of a div.

### Images in snippets

CMSimple has an image library where you can manage all of your images and then insert them into a region. From an authors standpoint setting an image in a snippet is no different. However on the development side it is not as clear cut. The reasoning for this is that CMSimple has to know which images are editable in a snippet and which are not. This is determined by a data attribute data-snippet-image. This attribute contains the name of the snippet option where the url to the image will be stored. Normally this is just "image" (see the content highlight snippet for an example). In a simple case this is all that is required to configure CMSimple to be able to update an image in a snippet. See the example
code below.

```erb
<img data-snippet-image="image" data-image-geometry="<150x<80" src="<%= @image.presence || 'http://placehold.it/60x80/' %>" alt="alt" />
```

The code above obviously does a bit more than set the image reference. This is two fold, first we want to provide the author a placeholder image that is an appropriate size so they know which image to replace (the img tag has to exist for this all to work). We accomplish this by checking if the image option has been set and if not we just a place holder image. The second attribute you see is the data-image-geometry attribute. This is used to automatically filter the image library by images that are of "recommended" size. We don't ever restrict an author from using an image we just suggest what was originally intended.

### Creating snippets

Beyond the items mentioned above the only other requirement for creating snippets is telling Mercury that they exist. This happens via the app/views/cmsimple/_snippet_list.html.erb partial. You need to add a new li with an img that has a data attribute data-snippet="name_of_snippet" the attribute name has to match the name of the cell. I can hear you saying "that sounds like a lot to remember". Well that is why there is a generator for creating snippets.

```shell
rails g cmsimple:snippet snippet_name field1 field2
```

Field1 and field2 are the options you want the author to be able to enter data for. The generator will create the cell and the display and options view as well as add itself to the snippet_list partial.


## Contributing

To run the test suite for CMSimple, you will need to do the following:

1. Setup the DB for testing
  1. Configure a `database.yml` in the demo rails app6 (see spec/rails_app/config/database.example.yml)
  2. Run setup tasks: `rake app:db:setup` and `rake app:db:test:prepare`
2. Run specs
  1. `rake`
  2. Wait.


## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2012 [Mode Set](https://github.com/modeset)


## Make Code Not War
![crest](https://secure.gravatar.com/avatar/aa8ea677b07f626479fd280049b0e19f?s=75)
