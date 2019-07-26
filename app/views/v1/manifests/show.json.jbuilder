seed = {
    '@id' => 'http://example.com/manifest',
    'label' => 'My Manifest'
}
# Any options you add are added to the object
manifest = IIIF::Presentation::Manifest.new(seed)

json.(manifest.to_json(pretty: true))
