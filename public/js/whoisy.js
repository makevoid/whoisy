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
    ResultView.prototype.className = "result_view";
    ResultView.prototype.initialize = function(opts) {
      this.model = opts["model"];
      console.log("view model:", this.model);
      return this.model.bind("change", this.gotResult, this);
    };
    ResultView.prototype.gotResult = function() {
      window.results_list.trigger("reset");
      return this.render();
    };
    ResultView.prototype.render = function() {
      var cont, content, haml;
      console.log("render model");
      cont = $("." + this.className).html();
      haml = Haml(cont);
      content = haml(this.model.attributes);
      return content;
    };
    return ResultView;
  })();
  ResultsView = (function() {
    __extends(ResultsView, Backbone.View);
    function ResultsView() {
      ResultsView.__super__.constructor.apply(this, arguments);
    }
    ResultsView.prototype.className = "results_view";
    ResultsView.prototype.element = ".results";
    ResultsView.prototype.initialize = function(opts) {
      this.model = opts["model"];
      window.deb = this.model;
      console.log("opt: ", this.model);
      return this.model.bind("change", this.render, this);
    };
    ResultsView.prototype.render = function() {
      var content, result, result_attrs, view, _i, _len, _ref, _results;
      console.log("render");
      _ref = this.model.attributes.results;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        result_attrs = _ref[_i];
        result = new Result(result_attrs);
        console.log(result);
        view = new ResultView({
          model: result
        });
        content = view.render().el;
        console.log("content: ", content);
        _results.push(this.$(this.element).append(content));
      }
      return _results;
    };
    return ResultsView;
  })();
  Whoisy = (function() {
    __extends(Whoisy, Backbone.Router);
    function Whoisy() {
      Whoisy.__super__.constructor.apply(this, arguments);
    }
    Whoisy.prototype.initialize = function() {
      var resultsView;
      this.results_list = new ResultsList();
      window.results_list = this.results;
      this.results = new Results({
        id: "makevoid.com"
      });
      this.results_list.add([this.results]);
      resultsView = new ResultsView({
        model: this.results
      });
      return this.results.fetch();
    };
    Whoisy.prototype.initSearch = function() {
      return $(function() {
        return $("#search").bind("submit", function() {
          return window.whoisy.query($("input.domain").val());
        });
      });
    };
    Whoisy.prototype.query = function(domain) {
      return this.result.fetch(domain);
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
