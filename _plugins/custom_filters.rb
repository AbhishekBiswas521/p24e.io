module Jekyll
  module CustomFilters

    def collect_posts(pages, max, more_posts)
      return [] if !pages || !pages.first
      posts = pages.map {|page| Array(page.data['posts']) }.flatten
      posts += Array(more_posts)
      posts.sort! {|a, b| a['date'] <=> b['date'] }
      posts[0...max]
    end

    # This assumes the URL structure we defined in _config.yml
    def collection_image(document_name, collection_name)
      srcimg = File.join("_#{collection_name}", 'assets', "#{document_name}.png")
      tgtimg = File.join('/', collection_name, 'assets', "#{document_name}.png")
      if File.exists?(srcimg)
        %(<img src="#{tgtimg}" class="collection_image" alt="#{document_name}"/>)
      else
        ''
      end
    end

    # Resolves to a field of a document in a collection given its document_name.
    # See also _plugins/document_name.rb
    def resolve_collection(document_name, collection_name, field_name, alt_field_name = nil)
      site = @context.registers[:site]
      coll = site.collections[collection_name] || raise("no valid collection: #{collection_name}")
      docu = coll.docs.find { |d| d.basename_without_ext == document_name }
      return '' unless docu
      docu.data[field_name] || docu.data[alt_field_name || field_name]
    end

  end
end

Liquid::Template.register_filter(Jekyll::CustomFilters)
