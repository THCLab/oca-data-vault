require 'roda'
require 'mongo'

class Web < Roda
  plugin :json

  db_client = Mongo::Client.new(
    ['mongodb:27017'], database: 'files_metadata'
  )

  route do |r|
    r.root do
      r.redirect('api/files')
    end

    r.on 'api' do
      r.on 'files' do
        r.get String do |hashlink|
          service = ::Services::GetRecordService.new(db_client)
          record, file = service.call(hashlink)
          return unless record && file

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
          db_client[:meta].find.to_a
        end
      end
    end
  end
end
