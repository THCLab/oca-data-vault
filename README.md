# OCA Data Vault

### API
* `POST /api/files` uploads file and returns record `id`  
  _eg._ `curl -F 'file=@/path/to/file' localhost:9292/api/files`  

* `GET /api/files` returns array of all records for uploaded files  
* `GET /api/files/{id}` triggers downloading file for provided record `id`
