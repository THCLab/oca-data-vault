require 'roda'

class Web < Roda
  plugin :json

  route do |r|
    r.root do
      {
        data: 'Hello world'
      }
    end
  end
end
