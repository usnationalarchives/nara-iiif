class V1::ManifestsController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    @manifests = Item.all
  end

  # Constuct a manifest from the requested Item record
  def show
    seed = {
      "@id" => helpers.v1_manifest_url(@item.naId),
      # `attribution` should map to Item.contributors
      "attribution" => "U.S. House of Representatives. 3/4/1789-",
      "label" => "NARA IIIF Prototype Presentation Manifest: #{@item.title}",
      # `license` should map Item.useRestrictions to the appropiate URI here:
      # https://rightsstatements.org/page/1.0/?language=en#collection-nc
      "license" => "http://rightsstatements.org/vocab/NoC-US/1.0/",
      "viewingDirection" => "left-to-right",
      "viewingHint" => "paged"
    }

    # Assign vales to the top level manifest object
    manifest = IIIF::Presentation::Manifest.new(seed)

    # Create an instance of a sequence
    sequence = IIIF::Presentation::Sequence.new()

    # Iterate over all the Record Objects associated with the Item to 
    # create a canvas in the manifest
    @item.record_objects.each do |record_object|
      # Create a new canvas instance
      canvas = IIIF::Presentation::Canvas.new()
      # All classes act like `ActiveSupport::OrderedHash`es, for the most part.
      # Use `[]=` to set JSON-LD properties...
      canvas['@id'] = "#{ENV.fetch("IMAGE_API_URL")}/item/2/#{record_object.id}"
      # ...but there are also accessors and mutators for the properties mentioned in
      # the spec

      # Construct the Image info.json url
      iiif_url = URI("#{helpers.iiif_id_url(record_object.image)}/info.json")
      # Fetch the Image info.json
      # NOTE: this is a workaround for the limitiation described below
      iiif_json = Net::HTTP.get(iiif_url)
      # ActiveStorage is not able to read metadata from non image resources
      # Instead, we read the value defined by the Image API info.json
      canvas.width = JSON.parse(iiif_json)['width'] rescue 100
      canvas.height = JSON.parse(iiif_json)['height'] rescue 100
      canvas.label = record_object.label

      # Insert each Record Object as an image reference within the canvas
      canvas.images << IIIF::Presentation::Annotation.new(
        # '@id' => "#{ENV.fetch("IMAGE_API_URL")}/item/2/#{record_object.id}",
        'on' => "#{ENV.fetch("IMAGE_API_URL")}/item/2/#{record_object.id}",
        'height' => canvas.height,
        'width' => record_object.image.image.metadata[:width],
        'resource' => IIIF::Presentation::ImageResource.new(
          '@id' =>  helpers.iiif_url_from_params(record_object.image),
          'height' => canvas.height,
          'width' => canvas.width,
          'service' => {
            "profile" => "http://iiif.io/api/image/2/level1.json",
            "@context" => "http://iiif.io/api/image/2/context.json",
            '@id' => helpers.iiif_id_url(record_object.image)
          }
        )
      )

      # Append the canvas to the canvases sequences canvases attribute
      sequence.canvases << canvas

    end

    # Append the sequence to the manifest
    manifest.sequences << sequence

    # Return a JSON response of the manifest
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
