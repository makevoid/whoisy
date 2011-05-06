function centerUI() {
  var search = $(".search");
  var searchHeight = search.height()
  var centerY = ($(document).height())/2 - searchHeight/2 - searchStartY
  search.css("webkitTransform", "translate(0, "+centerY+"px)")
  console.log($(document).height())
}

var searchStartY = $(".search").offset().top

function ui() {
  centerUI()
  
  $(window).resize(function() {
    centerUI()
  })
}

function do_search() {
  data = $("form#search").serialize()
  //console.log(data)
  $("#spinner").show("fast")
  $("#results").fadeOut("fast")
  $.ajax({
    url: "/search.json",
    dataType: 'json',
    type: "POST",
    data: data,
    success: function(data){    
      $("#spinner").hide()
      $("#results").fadeIn("fast")
      
      var html = Mustache.to_html(template, data)
      $("#results").html(html)
    }
  }) 
}


function prevent_default(event) {
  event.preventDefault ? event.preventDefault() : event.returnValue = false
  if(event.preventDefault){ event.preventDefault()}
     else{event.stop()}
  
  event.stopPropagation()
}

$("form#search").live('submit', function(e){
  do_search()
  
  prevent_default(e)
  return false
})

$("form#search input.submit").click(function(e){
  do_search()
  prevent_default(e)
  return false
})


function templates() {
  var template = $("#result_tmpl").html()
}

$(function(){
  //ui()
  
  templates()
})