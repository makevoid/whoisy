# APP

### analytics

https://www.google.com/analytics/settings/home?scid=ANALYTICS_ID

### textmate js

function open_in_textmate(path) {
  app_name = "APP_NAME"
  url = "txmt://open?url=file://~/Sites/"+app_name+"/"+path
  document.location = url
}

$("#open").click(function(){
  file = "views/index.haml"
  open_in_textmate(file)
})
