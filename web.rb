require 'roda'
require 'mongo'
require 'mime/types'

require 'plugins/cors'

class Web < Roda
  plugin :cors
  plugin :json

  db_client = Mongo::Client.new(
    [MONGODB_URI], database: 'files_metadata'
  )

  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.on 'files' do
          r.get String do |hashlink|
            service = ::Services::V1::GetRecordService.new(db_client)
            record, file = service.call(hashlink)
            return { errors: ['record not found'] } unless record && file
            response.headers['Content-Type'] = MIME::Types.type_for(record[:filetype]).first&.content_type || 'text/plain'
            response.headers['Content-Disposition'] =
              "attachment; filename=\"#{record[:filename]}.#{record[:filetype]}\""
            file.read
          end

          r.post do
            service = ::Services::V1::NewRecordService.new(db_client, ::SaiGenerator)
            service.call(r.params)
          end

          r.is do
            service = ::Services::V1::GetRecordsService.new(db_client)
            service.call
          end
        end
      end
    end
  end
end
