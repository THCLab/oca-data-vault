# frozen_string_literal: true

require 'hashlink'

module Services
  class NewRecordService
    attr_reader :db_client

    def initialize(db_client)
      @db_client = db_client
    end

    def call(raw_params)
      params = validate(raw_params)
      name, type = split_name_and_type(params[:file][:filename])
      file = params[:file][:tempfile]
      content_hashlink = Hashlink.encode(data: file.read).split(':')[1]
      FileUtils.cp(file.path, ROOT_PATH + '/storage/' + content_hashlink)

      data = {
        filename: name, filetype: type, content_hashlink: content_hashlink
      }
      hashlink = Hashlink.encode(data: data.to_json).split(':')[1]

      db_client[:meta].update_one(
        { _id: hashlink },
        data.merge(_id: hashlink),
        upsert: true
      )
      hashlink
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
