# frozen_string_literal: true

module Services
  module V2
    class NewRecordService
      attr_reader :hashlink_generator

      def initialize(hashlink_generator)
        @hashlink_generator = hashlink_generator
      end

      def call(raw_params)
        params = validate(raw_params)
        file = params[:file][:tempfile]
        content = JSON.parse(file.read)
        content_hashlink = hashlink_generator.call(content)
        FileUtils.cp(file.path, File.join(STORAGE_PATH, content_hashlink))

        {
          sai: content_hashlink,
          content: content
        }
      end

      def validate(params)
        return unless params['file']
        {
          file: params['file']
        }
      end
    end
  end
end
