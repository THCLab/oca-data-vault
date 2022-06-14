# frozen_string_literal: true

module Services
  module V1
    class NewRecordService
      attr_reader :db_client, :hashlink_generator

      def initialize(db_client, hashlink_generator)
        @db_client = db_client
        @hashlink_generator = hashlink_generator
      end

      def call(raw_params)
        params = validate(raw_params)
        name, type = split_name_and_type(params[:file][:filename])
        file = params[:file][:tempfile]
        content_hashlink = hashlink_generator.call(file.read)
        FileUtils.cp(file.path, File.join(STORAGE_PATH, content_hashlink))

        data = {
          filename: name, filetype: type, content_hashlink: content_hashlink
        }
        record_hashlink = hashlink_generator.call(data.to_json)

        db_client[:meta].update_one(
          { _id: record_hashlink },
          data.merge(_id: record_hashlink),
          upsert: true
        )
        {
          record_sai: record_hashlink,
          content_sai: content_hashlink
        }
      end

      def validate(params)
        return unless params['file']
        {
          file: params['file']
        }
      end

      private def split_name_and_type(filename)
        splited_name = filename.split('.')
        type = splited_name.size > 1 ? splited_name.pop : nil
        name = splited_name.join('.')
        [name, type]
      end
    end
  end
end
