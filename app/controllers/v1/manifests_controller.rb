class V1::ManifestsController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    @manifests = Item.all
  end

  def show
    seed = {
      '@id' => 'http://example.com/manifest',
      'label' => "NARA IIIF Prototype Presentation Manifest: #{@item.title}"
    }
    # Any options you add are added to the object
    manifest = IIIF::Presentation::Manifest.new(seed)

    sequence = IIIF::Presentation::Sequence.new(
      'viewingDirection' => "left-to-right"
    )

    # range = IIIF::Presentation::Range.new(
    #   '@id' =>
    # )

    @item.record_objects.each do |record_object|
      canvas = IIIF::Presentation::Canvas.new()
      # All classes act like `ActiveSupport::OrderedHash`es, for the most part.
      # Use `[]=` to set JSON-LD properties...
      canvas['@id'] = "#{ENV.fetch("IMAGE_API_URL")}/item/2/#{record_object.id}"
      # ...but there are also accessors and mutators for the properties mentioned in
      # the spec

      iiif_url = URI("#{helpers.iiif_id_url(record_object.image)}/info.json")
      iiif_json = Net::HTTP.get(iiif_url)
      canvas.width = JSON.parse(iiif_json)['width']
      canvas.height = JSON.parse(iiif_json)['height']
      canvas.label = record_object.label

      # oc = IIIF::Presentation::Resource.new('@id' => 'http://example.com/content')
      # canvas.other_content << oc

      canvas.images << IIIF::Presentation::Annotation.new(
        # '@id' => "#{ENV.fetch("IMAGE_API_URL")}/item/2/#{record_object.id}",
        'on' => "#{ENV.fetch("IMAGE_API_URL")}/item/2/#{record_object.id}",
        'height' => canvas.height,
        'width' => record_object.image.image.metadata[:width],
        # 'service_id' => "#{ENV.fetch("IMAGE_API_URL")}/iiif/2",
        # 'resource_id' => helpers.iiif_url_from_params(record_object.image),
        # 'resource_id' => "#{ENV.fetch("IMAGE_API_URL")}/iiif/2",
        'resource' => IIIF::Presentation::ImageResource.new(
          '@id' =>  helpers.iiif_url_from_params(record_object.image),
          'height' => canvas.height,
          'width' => canvas.width,
          'service' => {
            "profile" => "http://iiif.io/api/image/2/level1.json",
            "@context" => "http://iiif.io/api/image/2/context.json",
            '@id' => helpers.iiif_id_url(record_object.image)
          }
        ),
      )

      # canvas.thumbnail =  {
      #   '@id' => helpers.iiif_url_from_params(record_object.image, { size: 100})
      # }

      sequence.canvases << canvas

    end
    manifest.sequences << sequence


    respond_to do |format|
        format.json { render json: manifest.to_json(pretty: true), status: :ok}
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.includes(record_objects: [:image]).where({naId: params[:id]}).first()
    end


end
