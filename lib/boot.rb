require 'services/new_record_service'
require 'services/get_record_service'
require 'services/get_records_service'

STORAGE_PATH = File.join(ROOT_PATH, 'storage')
MONGODB_URI = ENV['MONGODB_URI'] || 'mongodb:27017'
