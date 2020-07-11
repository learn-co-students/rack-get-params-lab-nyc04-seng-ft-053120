class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      # this creates a new route called cart that show the items in the cart if the cart is not empty, and if it is, should write that cart is empty
      (@@cart.empty?) ? (resp.write "Your cart is empty") : (@@cart.each { |item| resp.write "#{item}\n"})
    elsif req.path.match(/add/)
      # this creates a new route called add that takes in a GET param with the key "item"
      add_term = req.params["item"]
      # check to see if that item is in @@items, add to cart if it is, otherwise give error
      if @@items.include?(add_term)
        @@cart << add_term
        resp.write "added #{add_term}"
      else
        resp.write "We don't have that item"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
