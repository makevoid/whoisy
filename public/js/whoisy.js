(function() {
  var Domain, Result, ResultView, Results, ResultsList, ResultsView, Whoisy, g;
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
  ResultView = (function() {
    __extends(ResultView, Backbone.View);
    function ResultView() {
      ResultView.__super__.constructor.apply(this, arguments);
    }
    ResultView.prototype.initialize = function(opts) {
      this.model = opts["model"];
      return this.model.bind("change", this.gotResult, this);
    };
    ResultView.prototype.gotResult = function() {
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
      return this.model.bind("change", this.render, this);
    };
    ResultsView.prototype.render = function() {
      var content, result, result_attrs, view, _i, _len, _ref, _results;
      console.log("render", this.model.attributes.results);
      _ref = this.model.attributes.results;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        result_attrs = _ref[_i];
        console.log("attrs: ", result_attrs);
        result = new Result(result_attrs);
        view = new ResultView({
          model: result
        });
        content = view.render().el;
        $(this.el).append(content);
        $("#results").prepend(this.el);
        _results.push(this.open());
      }
      return _results;
    };
    ResultsView.prototype.open = function() {
      var height;
      height = "300px";
      return $("#plate_bottom").anim({
        top: height
      });
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
    Whoisy.prototype.initialize = function() {};
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
      return this.results.fetch();
    };
    return Whoisy;
  })();
  g = window;
  g.whoisy = new Whoisy;
  whoisy.initSearch();
  $(function() {
    $("button.refresh").bind("click", function() {
      return document.location = "/";
    });
    $(".search").fadeIn('slow');
    if ($.os.ios) {
      return $("body").addClass("ios");
    } else {
      return $("input.domain").focus();
    }
  });
}).call(this);
