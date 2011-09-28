var cache = {};

function centerUI() {
  var search = $("#src, header")
  var searchHeight = $(".search").height()
  var centerY = ($(document).height())/2 - searchHeight/2 - searchStartY
  search.css("webkitTransform", "translate(0, "+centerY+"px)")
  //console.log($(document).height())
}

var searchStartY = $(".search").offset().top

var ui_animated = false
function ui() {
  ui_animated = true
  centerUI()
  
  $(window).resize(function() {
    centerUI()
  })
}

function search_animation() {
  var src = document.getElementById("src")

  src.style.webkitTransform = "rotate(-20deg)"
  var search = $("#src, header")
  search.css("webkitTransform", "translate(0, "+0+"px)")
}

function do_search() {	
  //console.log(data)
  //$("#spinner").show("fast")
  //$("#results").fadeOut("fast")
  $("#results").html('<img class="spinner" src="/imgs/spinner.gif">')
  
  if (ui_animated) 
    search_animation()  
  
  $.ajax({
    url: "/whois/"+$("form#search #name").val()+".json",
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
	$("form#search input").live('submit', function(e){
	  do_search()

	  prevent_default(e)
	  return false
	})

	$("#search input#query").click(function(e){
	  do_search()
	  prevent_default(e)
	  return false
	})  

	var template = $("#result_tmpl").html()
}

function whois_completed(elem) {
  
  //elem.animate({width: "100%" }, 500)
}

//
// var src = document.getElementById("src")
// 
// src.addEventListener('webkitAnimationEnd', function(){
//   alert("a")
// }, false)
// src.style.webkitTransform = "translate(0)"
// var search = $("#src, header")
// search.css("webkitTransform", "translate(0, "+0+"px)")


function addEventsWebkit() {
  var details = document.getElementById("details")
  details.addEventListener('webkitAnimationEnd', function(){
    alert("a")
  }, false)
}

function prefs_render() {
  $.getJSON("/tld.json", function(data){
    var html = Mustache.to_html($("#prefs_tmpl").html(), data)
    whois_render(html)
    setTimeout(function(){prefs_tld_update()},100)
  })
}

function whois_render(html) {
  $("#details").css("display", "block")
  setTimeout(function(){ 
    $("#details .cont").html(html)
    $("#details").css("opacity", 1)
  }, 100)
  // $("#details").animate({opacity: 1}, 800)
  // $("#details").addClass("open")
}

function whois_close() {
  // $("#details").animate({opacity: 0}, 800, function(){
  //   $("#details").removeClass("open")
  // })

  $("#details").css("opacity", 0)
  setTimeout(function(){ 
    $("#details").css("display", "none")
  }, 800)
}

function whois_open(elem) { 
  $("#details").unbind("click")
  $("#details").bind("click", function() {
    whois_close()
  })
  
  
  // whois_window_open
  elem.attr("data-whois-status", "opened")
  //$(this).css("width", "60%")
  //elem.animate({ width: "60%" }, 500)

  var name = elem.attr("data-name")
  $.getJSON("/whois/"+name+"/infos.json", function(data){
    whois_completed(elem)

    // TODO: renderizzare con moustache
    console.log(data)
    var html = Mustache.to_html($("#whois_tmpl").html(), data)
    //elem.append(html)
  
    cache[name] = html
    whois_render(html)
  })
}

function whois_window_close(elem) {
  elem.attr("data-whois-status", "closed")
  elem.animate({ width: "50%" }, 500)
  elem.find(".whois_box").fadeOut()
}

function whois_window_reopen(elem) {
  elem.attr("data-whois-status", "opened")
  elem.animate({ width: "80%" }, 500)
  elem.find(".whois_box").fadeIn()
}


/* local storage and preferences */

function prefs_tld_add(tld) {
  if (!Modernizr.localstorage)
    return

  var ls = localStorage.getItem("whoisy.tld")
  var tlds = ls != null ? eval(ls) : new Array()
    
  if (jQuery.inArray(tld,tlds) == -1) {
    tlds.push(tld);
    localStorage.setItem("whoisy.tld",JSON.stringify(tlds));
  }
}

function prefs_tld_rem(tld) {
  if (!Modernizr.localstorage)
    return
  
  var ls = localStorage.getItem("whoisy.tld")
  
  if (ls == null)
    return

  var tlds = eval(localStorage.getItem("whoisy.tld"));
  var index = jQuery.inArray(tld,tlds)

  if (index != -1) {
    tlds.splice(index,1)
    localStorage.setItem("whoisy.tld",JSON.stringify(tlds));
  }
}

function prefs_tld_clear() {
  if (!Modernizr.localstorage)
    return
  
  localStorage.removeItem("whoisy.tld")
}

function prefs_tld_get() {
  if (!Modernizr.localstorage)
    return
    
  return eval(localStorage.getItem("whoisy.tld"));
}

function prefs_tld_is_set(tld) {
  var tlds = eval(localStorage.getItem("whoisy.tld"))
  
  
  if (tlds == null || jQuery.inArray(tld,tlds) == -1)
    return false
  else
    return true
}

function prefs_tld_update() {
  jQuery("form#tlds input[type=checkbox]").each(function(i){
    var t = jQuery(this)
    
    if (prefs_tld_is_set(t.attr("value")))
      t.attr('checked', 'true')
    else
      t.removeAttr('checked')
      
    t.unbind('click')
    
    t.click(function(){
      if (prefs_tld_is_set(t.attr("value"))) {
        t.removeAttr('checked')
        prefs_tld_rem(t.attr("value"))
      }
      else {
        t.attr('checked','true')
        prefs_tld_add(t.attr("value"))
      }
    })
  })
}

function eventsDesktop() {
  $("#results li").live("click", function(){
    var elem = $(this)
    
    switch($(this).attr("data-whois-status")) { 
      case "opened": 
        whois_window_close(elem)
      break; 
      case "closed": 
        whois_window_reopen(elem)
      break; 
      default: 
        whois_window_open(elem)
    }
  })
}

function eventsMobile() {
  $("#results li").live("click", function(){
    var elem = $(this)
    var html = cache[elem.attr("data-name")]
    
    if (html)
      whois_render(html)
    else
      whois_open(elem)
      
  })
  
  $("#prefs_close").live("click", function() { whois_close() })
  
  $("#search input#prefs").bind("click", function() { prefs_render(); $("#details").unbind("click") })
}
 
$(function(){
  //ui()
	templates()
	
  // eventsDesktop()
  eventsMobile()	
  
  if (!navigator.userAgent.match(/Chrome/))
    $("#search input[type=text]").attr("type", "url")
})