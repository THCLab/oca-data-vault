# frozen_string_literal: true

require 'hashlink'

module Services
  class NewRecordService
    def call(params)
      data = validate(params)
      splited_name = data.fetch(:file)[:filename].split('.')
      type = splited_name.size > 1 ? splited_name.pop : nil
      name = splited_name.join('.')

      file = data.fetch(:file)[:tempfile]
      content_hashlink = Hashlink.encode(data: file.read).split(':')[1]
      FileUtils.cp(file.path, ROOT_PATH + '/storage/' + content_hashlink)

      link = {
        filename: name, filetype: type, content_hashlink: content_hashlink
      }
      hashlink = Hashlink.encode(data: link.to_json).split(':')[1]
    end

    def validate(params)
      return unless params['file']
      {
        file: params['file']
      }
    end
  end
end
