module ViewHelpers
  def body_class
    req = request.path.split("/")
    req[1..2] || "index home"
  end
end