require 'roda'
require 'mongo'

class Web < Roda
  plugin :json

  db_client = Mongo::Client.new(
    [MONGODB_URI], database: 'files_metadata'
  )

  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.on 'files' do
          r.get String do |hashlink|
            service = ::Services::GetRecordService.new(db_client)
            record, file = service.call(hashlink)
            return { errors: ['record not found'] } unless record && file

            response.headers['Content-Disposition'] =
              "attachment; filename=\"#{record[:filename]}.#{record[:filetype]}\""
            file.read
          end

          r.post do
            service = ::Services::NewRecordService.new(db_client)
            hashlink = service.call(r.params)

            hashlink
          end

          r.is do
            service = ::Services::GetRecordsService.new(db_client)
            service.call
          end
        end
      end
    end
  end
end
