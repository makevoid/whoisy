# models
class Domain extends Backbone.Model

class Result extends Backbone.Model

# mollection
class Results extends Backbone.Model
  initialize: ->
    this.bind("change", this.results, this)

  results: ->
    if (this.attributes.error)
      this.gotError(this.attributes.error)
    else
      this.trigger("gotResult")

  gotError: (error) ->
    console.log "got Error: ", error

# collections
class ResultsList extends Backbone.Collection
  model: Result
  url: "/whois"


# views
class LoaderView extends Backbone.View
  element: ".standalone_loader"
  element: ".spinner"

  constructor: ->
    @spinner = $(@element)
  # TODO: horizontal loader

  load: ->
    @spinner.show("slow")
    # $(@element).anim(backgroundColor: "#000000")

  loaded: ->
    @spinner.hide("fast")
    # $(@element).anim(backgroundColor: "#FFE100")


class ResultView extends Backbone.View

  initialize: (opts) ->
    @model = opts["model"]
    @model.bind("change", this.resetAndRender, this)

  resetAndRender: ->
    window.results_list.trigger("reset")
    this.render()

  render: ->
    cont = $(".result_view").html()
    haml = Haml(cont)
    content = haml(@model.attributes)
    $(@el).html(content)
    this


class ResultsView extends Backbone.View
  element: ".results"

  initialize: (opts) ->
    # console.log @collection
    @model = opts["model"]
    window.deb = @model
    @model.bind("gotResult", this.render, this)
    @is_open = false

  render: ->
    window.loader.loaded()
    # console.log "render", @model.attributes.results
    $(@el).html("")
    $(".results_list div").remove()
    for result_attrs in @model.attributes.results
      result = new Result(result_attrs)
      view = new ResultView(model: result)
      content = view.render().el

      $(@el).append content

      $(".results_list").prepend @el
      # FIXME: hardcoded height
      # height = $(".results_list").height()

      this.open()

  open: ->
    height = $("body").height() - 300 # height_1
    height = $(".results_list").height() + 20*2.5 # height_2
    $("#plate_bottom").anim({ top: "#{height}px" })
    @is_open = true

  close: ->
    $("#plate_bottom").anim({ top: 0 })


# controller
class Whoisy extends Backbone.Router
  initialize: ->
    $( ->
      # window.whoisy.query("makevoid.com")
      # window.whoisy.query("mkvd.net")
    )
    window.loader = new LoaderView()

  initSearch: ->
    $( ->

      $("#search").bind("submit", ->
        window.whoisy.query( $("input.domain").val() )
      )
    )

  query: (domain) ->
    @results_list = new ResultsList()
    window.results_list = @results
    @results = new Results(id: domain)
    @results_list.add [@results]
    resultsView = new ResultsView( model: @results )
    resultsView.close()
    @results.fetch({ error: -> window.loader.loaded()  })
    window.loader.load()

g = window
g.whoisy = new Whoisy
whoisy.initSearch()

# Backbone.history.start({
#   pushState: true
# })



$( ->
  $("body").bind("touchmove", (evt) ->
    evt.preventDefault()
  )


  $("button.refresh").bind("click", ->
    document.location = "/"
  )


  $(".search").fadeIn('slow')

  if ($.os.ios)
    $("body").addClass "ios"
  else
    $("input.domain").focus()

  # height = 170 # height_1
  height = $(".results_list").height() + 20 # height_2
  $("#plate_bottom").height $("body").height() - height
  # $("#container").append $("html").attr('class')
)

