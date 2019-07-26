seed = {
    '@id' => 'http://example.com/manifest',
    'label' => 'My Manifest'
}
# Any options you add are added to the object
manifest = IIIF::Presentation::Manifest.new(seed)

canvas = IIIF::Presentation::Canvas.new()
# All classes act like `ActiveSupport::OrderedHash`es, for the most part.
# Use `[]=` to set JSON-LD properties...
canvas['@id'] = 'http://example.com/canvas'
# ...but there are also accessors and mutators for the properties mentioned in 
# the spec
canvas.width = 10
canvas.height = 20
canvas.label = 'My Canvas'

oc = IIIF::Presentation::Resource.new('@id' => 'http://example.com/content')
canvas.other_content << oc

manifest.sequences << canvas

puts manifest

json.(manifest)
