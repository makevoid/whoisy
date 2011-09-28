# models
class Domain extends Backbone.Model
  
class Result extends Backbone.Model
  

# mollection
class Results extends Backbone.Model
  
    
# collections
class ResultsList extends Backbone.Collection
  model: Result
  url: "/whois"
  

  
  
# views
class ResultView extends Backbone.View
  className: "result_view"
  
  initialize: (opts) ->
    @model = opts["model"]
    console.log "view model:", @model
    @model.bind("change", this.gotResult, this)


  gotResult: ->
    window.results_list.trigger("reset")
    this.render()

  render: ->
    console.log "render model"
    cont = $(".#{this.className}").html()
    # console.log "cont: ", cont
    haml = Haml(cont)
    content = haml(this.model.attributes)
    # console.log "tent: ", content
    content
  
  
class ResultsView extends Backbone.View
  className: "results_view"
  
  element: ".results"
  
  initialize: (opts) ->
    # console.log @collection
    @model = opts["model"]
    window.deb = @model
    console.log "opt: ", @model
    @model.bind("change", this.render, this)
    
  render: ->
    console.log "render"
    for result_attrs in @model.attributes.results
      result = new Result(result_attrs)
            
      console.log result
      view = new ResultView(model: result)
      content = view.render().el
      console.log "content: ", content
      this.$(@element).append content
    

# controller
class Whoisy extends Backbone.Router
  initialize: ->
    @results_list = new ResultsList()
    window.results_list = @results
    @results = new Results(id: "makevoid.com")
    @results_list.add [@results]
    resultsView = new ResultsView( model: @results )
    # @resultsView = new ResultsView( collection: @results )
    # @results.fetch()
    # @result.fetch("makevoid.com")
    @results.fetch()
  initSearch: ->
    $( -> 
      $("#search").bind("submit", ->
        window.whoisy.query( $("input.domain").val() )
      )
    )
  
  query: (domain) ->
    @result.fetch(domain)
 
g = window 
g.whoisy = new Whoisy
whoisy.initSearch()

# Backbone.history.start({
#   pushState: true
# })





$( -> 
  $("button.refresh").bind("click", ->
    document.location = "/"
  )

  $(".search").fadeIn('slow')
  
  
  if ($.os.ios)
    $("body").addClass "ios"
  else
    $("input.domain").focus()
  
  
  # $("#container").append $("html").attr('class')
    
  
)

