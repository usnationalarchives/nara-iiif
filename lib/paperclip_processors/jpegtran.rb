# To run the jpegtran command on JPG files output by Paperclip, you
# need to add
#
#   processors: [:thumbnail, :jpegtran]
#
# to your has_attached_file hash for each attachment in your project
# Thumbnail is the default paperclip processor, so you want to run that before
# jpegtran, which only minimizes JPG size and doesn't otherwise transform
# or crop image files

module Paperclip

  class Jpegtran < Processor

    attr_accessor :file, :options, :attachment

    def initialize file, options = {}, attachment = nil
      super
      @file = file
      @current_format = File.extname(@file.path)
      @basename = File.basename(@file.path, @current_format)
    end

    def make

      destination_file = Tempfile.new(@basename)
      destination_file.binmode

      begin

        success = Paperclip.run(
          "jpegtran", "-copy none -optimize -perfect :source > :dest",
          source: File.expand_path(@file.path),
          dest: File.expand_path(destination_file.path)
        )

      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "There was an error processing the thumbnail for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `jpegtran` command. Please install jpegtran.")
      rescue Exception => e
        Rails.logger.error "There was an error running `jpegtran` on the thumbnail for #{@basename}. Check that jpegtran is installed."
        Rails.logger.error e.message
      end

      return destination_file

    end

  end

end
