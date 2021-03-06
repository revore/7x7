logDebug = false

places = [
  "Sardine Chips at Rich Table",
  "Mac and Cheese at Citizen's Band",
  "Chicken Wings at San Tung",
  "Carnitas Taco at La Taqueria",
  "Chicago Dog at Da Beef",
  "Corned Beef Reuben on rye pan loaf at Bar Tartine's Sandwich Shop",
  "Princess Cake at Schubert's Bakery",
  "Mandilli al pesto at Farina",
  "Hash brown sandwich at Art's Cafe",
  "Gateau Basque at Piperade",
  "Jewish style artichokes at Locanda",
  "Stuffed falafel at Old Jerusalem",
  "Xiao long bao at Yank Sing",
  "Preserved lemon 6:10 at Coi",
  "Sugar Egg Puffs at Shanghai Dumpling King",
  "Hummus and house-made pita at Terzo",
  "Pizza Margherita at Una Pizza Napoletana",
  "Seasonal sformato at Cotogna",
  "Rebel Within at Craftsman & Wolves",
  "Angolotti dal plin at Perbacco",
  "Big Daddy ramen bowl at Hapa Ramen",
  "Quiche at Cassava Bakery and Cafe",
  "Ahmohk (curry fish mousse) at Angkor Borei",
  "Banana cream tart at Tartine Bakery",
  "Sloppy bun with an egg at Bun Mee",
  "Meatball, kale, and fregola soup at Claudine ",
  "Bix Club burger at Bix",
  "Roasted chicken and bread salad at Zuni Cafe",
  "Amatriciana pizza at Ragazza",
  "Pupusas at Balompie Cafe",
  "Prime Rib at House of Prime Rib",
  "Chicken katsu and tofu buns at Izakaya Yuzuki",
  "The Brass Monkey at Little Star Pizza",
  "Parisian empanada from El Sur truck",
  "Salted-caramel ice cream at Bi-Rice Creamery",
  "Garlic pretzels at Absinthe Brasserie & Bar",
  "Pasta tasting menu at SPQR",
  "Pan-seared chicken livers at Serpentine",
  "Egg custard tart at Golden Gate Bakery",
  "Goat taco at El Norteno taco truck",
  "Angry Korean wings at Wings Wings",
  "Beef and cheese piroshka at Anda Piroshki ",
  "Nojo sundae at Nojo",
  "Complete crepe at Galette 88",
  "Duck larb at Lers Ros Thai",
  "Blue Bottle Vietnamese coffee ice cream at Humphry Slocombe",
  "Chicken wings at Aziza",
  "Seafood chowder at Bar Crudo",
  "Banana split at The Ice Cream Bar",
  "Rosemary, fiore sardo, and pine nut pizza at Pizzetta 211",
  "Pho ga at Turtle Tower",
  "Caldo tlalpeno at Nopalito",
  "Katsiki youvetsi at Kokkari",
  "Almond croissant at Thorough Bread & Pastry",
  "A dozen Sweetwater oysters at Hog Island Oyster Co. ",
  "Fried plantain and black bean burrito at The Little Chihuahua",
  "Mission Burger at Mission Bowling Club",
  "Pork shoulder fried rice at Sai Jai Thai",
  "Fried Chicken Yum Yum at 4505 Meats",
  "Lamb tacos at El Huarache Loco",
  "The Crankshaft tuna melt at Machine Coffee and Deli",
  "Peking Duck at Hong Kong Lounge",
  "Chilaquiles Veronica at San Jalisco",
  "Manti at Troya Fillmore",
  "Renzo special at Molinari Delicatessen",
  "Vada pav at Dosa",
  "Meatloaf at The Blue Plate",
  "Foccacia at Liguria Bakery",
  "Omakase at ICHI",
  "Dogpatch Millionaire at Kitchenette",
  "Green onion buns at New Hollywood Bakery",
  "Sea urchin dish at Commonwealth",
  "The Boca at Deli Board",
  "Lobster xiao long bao at Benu",
  "Super carne asada burrito at El Farolito",
  "Faux gras ridged pasta at Acquerello",
  "Fried chicken at Foreign Cinema",
  "Jerk-spiced duck hearts at Alembic",
  "Biscuits at Brenda's French Soul Food",
  "Matzo ball soup at Wise Sons Delicatessen",
  "Pot Pie at Comstock Saloon",
  "Ikura at Ino Sushi",
  "Spicy miso ramen at Ramen Underground",
  "New York-style cheese slice at Tony's Slice House",
  "Pomme d'amour at Knead Patisserie",
  "Glazed roasted squab at Bodega Bistro",
  "Faith's warm ham and cheese toast at Town Hall",
  "Beggar's chicken at Betelnut ",
  "Beef tongue at Namu Gaji",
  "Warm bread, artichoke, and crescenza salad at Jardiniere",
  "Cumin lamb at Spices! II",
  "Crispy potatoes at Plow",
  "Bun rieu at Soup Junkie",
  "Whole wheat flour carrot cake at Farallon",
  "Deviled eggs at Park Tavern",
  "St. Honore cake from Dianda's Italian American Pastry",
  "Lamb shawerma from Truly Mediterranean",
  "Banh mi at Irving Cafe & Deli",
  "California state bird at State Bird Provisions",
  "Cracked Dungeness crab at Swan Oyster Depot"
]

Eat = Backbone.Model.extend
  defaults:
    place: ''
    done: false

EatsCollection = Backbone.Collection.extend
  model: Eat
  url: '/i/docs/eats.json'
  # localStorage: new Store('eats')

EatsCollection.prototype.create = (eat) ->
  isDupe = @any (_eat) ->
    _eat.get("place") is eat.place

  console.log "isDupe", isDupe if logDebug
  return false if isDupe
  Backbone.Collection.prototype.create.call this, eat

Eats = new EatsCollection([])
Eats.fetch().success ->
  console.log "fetch succes" if logDebug
  _.each places, (place) ->
    console.log "create", place if logDebug
    Eats.create({place})

console.log "len", Eats.length if logDebug

EatView = Backbone.View.extend
  tagName: 'li'
  template: _.template( $('#eat-template').html() )
  events:
    'click': 'toggleDone'
  render: ->
    console.log "render" if logDebug
    @$el.html( @template( @model.toJSON() ) )
    state = if @model.get("done") && @model.get("done") then "done" else "todo"
    $(@el).removeClass "done", "todo"
    $(@el).addClass state
    this
  initialize: ->
    @listenTo(@model, 'change', @render)
  toggleDone: ->
    return unless Juno.params.isOwner
    console.log "toggle done", @model.get("done"), !@model.get("done") if logDebug
    @model.save({done: !@model.get("done")})

EatsView = Backbone.View.extend
  el: '#eats'
  template: _.template( $('#eats-template').html() )
  render: ->
    console.log("lists view render") if logDebug
    @$el.html( @template() )
    this
  initialize: ->
    console.log("lists view initialize") if logDebug
    @listenTo(Eats, 'reset', @addAll)
    @listenTo(Eats, 'add', @redo)
    @listenTo(Eats, 'remove', @redo)
    @listenTo(Eats, 'create', @redo)
    @redo()
  redo: ->
    @render()
    @addAll()
  addOne: (eat) ->
    console.log("eat view add one", eat) if logDebug
    view = new EatView({ model: eat })
    $('#eats-list').append( view.render().el )
  addAll: ->
    console.log("list view add all", Eats.length) if logDebug
    @$('#eat-list').html('')
    Eats.each(@addOne, this)

new EatsView()

$("title").text("7x7 Eat list")
