module LinkHelper
  def link_to_object(object, name, html_options = nil, &block)
    path = case object
    when Iqvoc::Concept.base_class
      concept_path(id: object)
    when Iqvoc::Collection.base_class
      collection_path(id: object)
    when Label::Base
      label_path(id: object)
    end

    link_to name, path, html_options, &block
  end

  def render_skos_id(url)
    if url =~ %r{^https://([^.]+)\.openactive\.io/_([0-9a-f-]+)$}
      vocab_identifier = $1
      id = $2
      "https://openactive.io/#{vocab_identifier}##{id}"
    else
      url
    end
  end

  def render_property_url(property_name)
    if property_name =~ %r{^beta:(.+)$}
      property = $1
      "https://openactive.io/ns-beta/#" + property
    else
      property_name
    end
  end
end
