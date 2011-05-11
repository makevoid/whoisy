function centerUI() {
  var search = $(".search, header")
  var searchHeight = $(".search").height()
  var centerY = ($(document).height())/2 - searchHeight/2 - searchStartY
  search.css("webkitTransform", "translate(0, "+centerY+"px)")
  //console.log($(document).height())
}

var searchStartY = $(".search").offset().top

function ui() {
  centerUI()
  
  $(window).resize(function() {
    centerUI()
  })
}

function do_search() {	
  //console.log(data)
  //$("#spinner").show("fast")
  //$("#results").fadeOut("fast")
  
  $("#results").html('<img class="spinner" src="/images/spinner.gif">')
  
  $.ajax({
    url: "/whois/"+$("form#search input[type=text]").val()+".json",
    dataType: 'json',
    type: "GET",
    success: function(data){    
      //$("#spinner").hide()
      //$("#results").fadeIn("fast")

			//antani = data;
			
			

			for (var i = 0; i < data['results'].length; ++i)
			{
				if (data['results'][i]['available'])
					data['results'][i]['availableString'] = 'is available.'
				else
					data['results'][i]['availableString'] = 'is registered.'
			}
      var html = Mustache.to_html($("#result_tmpl").html(), data)
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

function templates() {
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

	var template = $("#result_tmpl").html()
}

$(function(){
  //ui()
	templates()
})