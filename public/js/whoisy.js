(function() {
  var Domain, LoaderView, Result, ResultView, Results, ResultsList, ResultsView, Whoisy, g;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Domain = (function() {
    __extends(Domain, Backbone.Model);
    function Domain() {
      Domain.__super__.constructor.apply(this, arguments);
    }
    return Domain;
  })();
  Result = (function() {
    __extends(Result, Backbone.Model);
    function Result() {
      Result.__super__.constructor.apply(this, arguments);
    }
    return Result;
  })();
  Results = (function() {
    __extends(Results, Backbone.Model);
    function Results() {
      Results.__super__.constructor.apply(this, arguments);
    }
    Results.prototype.initialize = function() {
      return this.bind("change", this.results, this);
    };
    Results.prototype.results = function() {
      if (this.attributes.error) {
        return this.gotError(this.attributes.error);
      } else {
        return this.trigger("gotResult");
      }
    };
    Results.prototype.gotError = function(error) {
      return console.log("got Error: ", error);
    };
    return Results;
  })();
  ResultsList = (function() {
    __extends(ResultsList, Backbone.Collection);
    function ResultsList() {
      ResultsList.__super__.constructor.apply(this, arguments);
    }
    ResultsList.prototype.model = Result;
    ResultsList.prototype.url = "/whois";
    return ResultsList;
  })();
  LoaderView = (function() {
    __extends(LoaderView, Backbone.View);
    function LoaderView() {
      LoaderView.__super__.constructor.apply(this, arguments);
    }
    LoaderView.prototype.element = ".standalone_loader";
    LoaderView.prototype.load = function() {};
    LoaderView.prototype.loaded = function() {};
    return LoaderView;
  })();
  ResultView = (function() {
    __extends(ResultView, Backbone.View);
    function ResultView() {
      ResultView.__super__.constructor.apply(this, arguments);
    }
    ResultView.prototype.initialize = function(opts) {
      this.model = opts["model"];
      return this.model.bind("change", this.resetAndRender, this);
    };
    ResultView.prototype.resetAndRender = function() {
      window.results_list.trigger("reset");
      return this.render();
    };
    ResultView.prototype.render = function() {
      var cont, content, haml;
      cont = $(".result_view").html();
      haml = Haml(cont);
      content = haml(this.model.attributes);
      $(this.el).html(content);
      return this;
    };
    return ResultView;
  })();
  ResultsView = (function() {
    __extends(ResultsView, Backbone.View);
    function ResultsView() {
      ResultsView.__super__.constructor.apply(this, arguments);
    }
    ResultsView.prototype.element = ".results";
    ResultsView.prototype.initialize = function(opts) {
      this.model = opts["model"];
      window.deb = this.model;
      this.model.bind("gotResult", this.render, this);
      return this.is_open = false;
    };
    ResultsView.prototype.render = function() {
      var content, result, result_attrs, view, _i, _len, _ref, _results;
      window.loader.loaded();
      $(this.el).html("");
      $(".results_list div").remove();
      _ref = this.model.attributes.results;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        result_attrs = _ref[_i];
        result = new Result(result_attrs);
        view = new ResultView({
          model: result
        });
        content = view.render().el;
        $(this.el).append(content);
        $(".results_list").prepend(this.el);
        _results.push(this.open());
      }
      return _results;
    };
    ResultsView.prototype.open = function() {
      var height;
      height = $("body").height() - 300;
      height = $(".results_list").height() + 20 * 2.5;
      $("#plate_bottom").anim({
        top: "" + height + "px"
      });
      return this.is_open = true;
    };
    ResultsView.prototype.close = function() {
      return $("#plate_bottom").anim({
        top: 0
      });
    };
    return ResultsView;
  })();
  Whoisy = (function() {
    __extends(Whoisy, Backbone.Router);
    function Whoisy() {
      Whoisy.__super__.constructor.apply(this, arguments);
    }
    Whoisy.prototype.initialize = function() {
      $(function() {});
      return window.loader = new LoaderView();
    };
    Whoisy.prototype.initSearch = function() {
      return $(function() {
        return $("#search").bind("submit", function() {
          return window.whoisy.query($("input.domain").val());
        });
      });
    };
    Whoisy.prototype.query = function(domain) {
      var resultsView;
      this.results_list = new ResultsList();
      window.results_list = this.results;
      this.results = new Results({
        id: domain
      });
      this.results_list.add([this.results]);
      resultsView = new ResultsView({
        model: this.results
      });
      resultsView.close();
      this.results.fetch();
      return window.loader.load();
    };
    return Whoisy;
  })();
  g = window;
  g.whoisy = new Whoisy;
  whoisy.initSearch();
  $(function() {
    var height;
    $("body").bind("touchmove", function(evt) {
      return evt.preventDefault();
    });
    $("button.refresh").bind("click", function() {
      return document.location = "/";
    });
    $(".search").fadeIn('slow');
    if ($.os.ios) {
      $("body").addClass("ios");
    } else {
      $("input.domain").focus();
    }
    height = $(".results_list").height() + 20;
    return $("#plate_bottom").height($("body").height() - height);
  });
}).call(this);
