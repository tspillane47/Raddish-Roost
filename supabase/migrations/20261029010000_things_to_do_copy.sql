-- Fuller descriptions and host tips for Things to Do.
-- Updates existing rows by name. Does not change which stays they are linked to.
-- Prohibition Pig moves back to Eat. Every other section stays as it is.
-- Run the Winooski and Raddish Things to Do files before this one.

do $body$
declare
  rec record;
begin
  for rec in
    select *
    from (
      values
    ($n$Waterworks Food + Drink$n$, $d$A lively restaurant in a restored mill building right on the Winooski River, with big windows looking out over the falls. Great for dinner, drinks, or a long lunch.$d$, $t$The steak frites are to die for. Ask for a table by the windows.$t$, null::text),
    ($n$Pho Hong$n$, $d$A no-frills Vietnamese spot that locals swear by for big, comforting bowls of pho and classic Vietnamese dishes.$d$, $t$Best Vietnamese in town. Mostly locals, and it's great for takeout on a cold night.$t$, null::text),
    ($n$Trattoria Delia$n$, $d$A cozy, candlelit Italian restaurant with rustic Northern Italian cooking and a warm, old-world feel. Perfect for a slow dinner.$d$, $t$Pop into Sotto, the wine bar next door, for a drink before or after.$t$, null::text),
    ($n$Restaurant Poco$n$, $d$A small, intimate tapas restaurant built for sharing plates and trying a bit of everything.$d$, $t$It's small and walk-in only, so go early or be ready to wait with a drink.$t$, null::text),
    ($n$Santiago's Cuban Cuisine$n$, $d$Authentic Cuban food and drinks in a relaxed, friendly setting. Hearty plates, bright flavors, and good cocktails.$d$, $t$Authentic and delicious. Come hungry.$t$, null::text),
    ($n$Honey Road$n$, $d$One of Burlington's most celebrated restaurants, serving Eastern Mediterranean small plates meant for sharing. A true standout.$d$, $t$Book your reservation well in advance. It fills up fast.$t$, null::text),
    ($n$Hen of the Wood (Burlington)$n$, $d$A Vermont favorite for farm-to-table dining, with seasonal menus built around local farms and producers.$d$, $t$Great for a special night out.$t$, null::text),
    ($n$Shanty on the Shore$n$, $d$A casual seafood spot near the Burlington waterfront with lake views and classic New England seafood.$d$, $t$Great seafood, and a fun stop after a walk along the lake.$t$, null::text),
    ($n$Onion City Chicken & Oysters$n$, $d$A Winooski spot doing crispy fried chicken, fresh oysters, and great cocktails.$d$, $t$The menu is short but delicious. Come in the mood for chicken or oysters.$t$, null::text),
    ($n$Taco Gordo$n$, $d$A local go-to for tacos and casual Mexican food.$d$, $t$Easy, tasty, and great for a quick bite.$t$, null::text),
    ($n$Farmhouse Tap & Grill$n$, $d$A Burlington favorite for burgers and local farm food, with a big Vermont beer list.$d$, $t$Grab the cozy basement by the fireplace in winter or the back patio in summer.$t$, null::text),
    ($n$Pascolo Ristorante$n$, $d$Italian comfort food with house-made pasta and pizza, right on Church Street.$d$, $t$Perfect for dinner before strolling Church Street at night.$t$, null::text),
    ($n$A Single Pebble$n$, $d$A longtime Burlington favorite for Chinese cooking and shareable dishes.$d$, $t$Order a bunch of plates and share family style.$t$, null::text),
    ($n$Leunig's Bistro$n$, $d$A classic French bistro on Church Street with a cozy, old-world atmosphere and great people watching.$d$, $t$Grab a window seat or a patio table in nice weather.$t$, null::text),
    ($n$May Day$n$, $d$A popular Burlington spot loved by locals.$d$, $t$A local favorite worth checking out.$t$, null::text),
    ($n$Spot on the Dock$n$, $d$A waterfront bar and restaurant right on Lake Champlain with outdoor seating and cocktails by the water.$d$, $t$Go at sunset. It's beautiful.$t$, null::text),
    ($n$Four Quarters Brewing$n$, $d$A Winooski brewery known for creative, small-batch beers and a laid-back taproom with good food.$d$, $t$Very chill and dog friendly.$t$, null::text),
    ($n$Foam Brewers$n$, $d$A Burlington brewery near the lake known for hazy IPAs, rotating small batch beers, and a great atmosphere.$d$, $t$Check for live music, and grab a spot on the outdoor patio in summer.$t$, null::text),
    ($n$Burlington Beer Co.$n$, $d$A big, lively beer hall with lots of house beers on tap and a full food menu.$d$, $t$Great for a larger group. The food is awesome too.$t$, null::text),
    ($n$Devil Takes a Holiday$n$, $d$An intimate cocktail bar with carefully made, high-quality drinks.$d$, $t$A great date night spot.$t$, null::text),
    ($n$Zero Gravity Brewery$n$, $d$One of Vermont's well-known breweries, with a big taproom pouring their own beers alongside good food.$d$, $t$A Burlington classic for a pint and a bite.$t$, null::text),
    ($n$The 126$n$, $d$A cozy speakeasy-style cocktail bar with dim lighting and live music.$d$, $t$Go for the live music and stay for a nightcap.$t$, null::text),
    ($n$Smugglers' Notch$n$, $d$A classic Vermont mountain known for challenging terrain and a great family program, with a real local feel.$d$, $t$Our local spot for skiing and snowboarding.$t$, null::text),
    ($n$Stowe Mountain Resort$n$, $d$One of the East's most famous ski resorts, at the base of Mount Mansfield, Vermont's highest peak.$d$, $t$It's on the Epic Pass. The Mountain Road is packed with bars and restaurants, and there's a spa, skating rink, and much more.$t$, null::text),
    ($n$Sugarbush Resort$n$, $d$A big, varied mountain in the Mad River Valley with lots of terrain for every level.$d$, $t$It's on the Ikon Pass.$t$, null::text),
    ($n$Bolton Valley Resort$n$, $d$A friendly, affordable mountain with a relaxed vibe, and one of the few places in Vermont with night skiing.$d$, $t$Great for beginners and kids. Don't miss night skiing.$t$, null::text),
    ($n$Trapp Family Lodge$n$, $d$The historic Stowe lodge founded by the von Trapp family, with miles of cross-country ski trails and sweeping mountain views.$d$, $t$Some of the best cross-country skiing around, and there's a brewery onsite.$t$, null::text),
    ($n$Shelburne Farms$n$, $d$A historic working farm and nonprofit on the shore of Lake Champlain, with walking trails, gardens, a cheese-making operation, and stunning views of the Adirondacks.$d$, $t$The trails are open all season (sorry, no dogs). In summer, grab a drink at the Inn and sit in the Adirondack chairs overlooking the water.$t$, null::text),
    ($n$Church Street$n$, $d$Burlington's pedestrian marketplace, lined with restaurants, boutiques, bars, coffee shops, and street performers. The heart of downtown.$d$, $t$Go after dark. It's all lit up at night.$t$, null::text),
    ($n$Spirit of Ethan Allen$n$, $d$A cruise boat on Lake Champlain offering scenic, dinner, and sunset cruises from the Burlington waterfront.$d$, $t$A great summer night out on the lake.$t$, null::text),
    ($n$Winooski Falls and river trails$n$, $d$The falls and riverwalk at the heart of Winooski, surrounded by historic mill buildings. An easy walk from your door.$d$, $t$Perfect for a morning coffee walk.$t$, null::text),
    ($n$Upper Hollow Road$n$, $d$A quiet country road in Stowe with classic Vermont views, especially in peak foliage.$d$, $t$Beautiful in the fall. Bring your camera.$t$, null::text),
    ($n$Mount Philo$n$, $d$Vermont's oldest state park, with a short climb (paved road or wooded trail) to a summit with sweeping views of Lake Champlain.$d$, $t$An easy hike with a big payoff. Dogs welcome on leash.$t$, null::text),
    ($n$Indian Brook Reservoir$n$, $d$A peaceful park in Essex with easy trails around the water.$d$, $t$Great walking trails, and dog friendly.$t$, null::text),
    ($n$Sterling Pond Trail$n$, $d$A popular hike up to a high mountain pond near Smugglers' Notch, on Vermont's Long Trail.$d$, null::text, null::text),
    ($n$Burnt Rock Mountain$n$, $d$A rugged climb to a wide-open rocky summit with big views of the Green Mountains.$d$, null::text, null::text),
    ($n$Camel's Hump$n$, $d$One of Vermont's most iconic peaks, with a distinctive shape and incredible summit views. A real Vermont bucket-list hike.$d$, $t$Not recommended for beginners. Start early and bring layers.$t$, null::text),
    ($n$Vermont Comedy Club$n$, $d$Burlington's comedy club, with stand-up and improv shows most weekends.$d$, $t$A fun night out when it's cold.$t$, null::text),
    ($n$Catamount Outdoor Family Center$n$, $d$A four-season outdoor center with trails for biking, cross-country skiing, and snowshoeing.$d$, $t$Rental equipment is available, so you don't need to bring gear.$t$, null::text),
    ($n$Shy Guy Gelato$n$, $d$Small-batch gelato in Burlington.$d$, null::text, null::text),
    ($n$Mr. Creemee Stand$n$, $d$A classic Vermont creemee stand. "Creemee" is what Vermonters call soft serve.$d$, $t$Try a maple creemee. It's a Vermont must.$t$, null::text),
    ($n$Blackback Pub$n$, $d$A cozy Waterbury pub with a seriously good craft beer list and a solid menu.$d$, $t$Great food and an excellent beer selection.$t$, null::text),
    ($n$Gallus Handcrafted Pasta$n$, $d$Fresh, handmade pasta in Waterbury.$d$, $t$Delicious Italian food.$t$, null::text),
    ($n$The Reservoir$n$, $d$A lively Waterbury restaurant and taproom with a long list of Vermont beers on tap and a laid-back menu.$d$, $t$Perfect for casual bites and a pint.$t$, null::text),
    ($n$Prohibition Pig$n$, $d$A Waterbury institution known for smoked meats, Southern-inspired comfort food, and its own beer.$d$, $t$There's a brewery around the back, so grab a beer there too.$t$, 'eat'),
    ($n$Park Row Cafe$n$, $d$A friendly, casual Waterbury breakfast and lunch spot.$d$, $t$Diner vibes!$t$, null::text),
    ($n$Salt & Rind$n$, $d$A Waterbury spot loved by locals.$d$, null::text, null::text),
    ($n$Maxi's$n$, $d$A Waterbury favorite for a relaxed meal.$d$, $t$Great for brunch!$t$, null::text),
    ($n$Michael's on the Hill$n$, $d$A long-standing fine dining restaurant in Waterbury Center.$d$, null::text, null::text),
    ($n$Stone's Throw Pizza$n$, $d$A local pizza spot in Waterbury.$d$, $t$Great for an easy pizza night in.$t$, null::text),
    ($n$The Alchemist Brewery$n$, $d$The Stowe brewery behind Heady Topper, one of the most famous beers in America.$d$, $t$A must for beer lovers. Grab some cans to bring home.$t$, null::text),
    ($n$Stowe Cider$n$, $d$A Stowe cidery making a wide range of hard ciders, from dry to fruity.$d$, $t$Great if you want a break from beer.$t$, null::text),
    ($n$Lawson's Finest Liquids$n$, $d$A beloved Vermont brewery with a beautiful taproom in Waitsfield, famous for Sip of Sunshine.$d$, $t$Worth the scenic drive through the Mad River Valley.$t$, null::text),
    ($n$Hender's Bake Shop & Cafe$n$, $d$A cozy Waterbury bakery and cafe.$d$, null::text, null::text),
    ($n$K.C.'s Bagel Café$n$, $d$A local Waterbury spot for bagels and breakfast sandwiches.$d$, null::text, null::text),
    ($n$Black Cap Coffee & Bakery$n$, $d$A Waterbury coffee shop and bakery with lunch, pastries, sandwiches, and lattes.$d$, null::text, null::text),
    ($n$Stowe Street Café$n$, $d$A friendly Waterbury cafe on Stowe Street.$d$, null::text, null::text),
    ($n$Vermont Artisan Coffee & Tea$n$, $d$A local coffee roaster in Waterbury Center, roasting their beans right on site.$d$, null::text, null::text),
    ($n$Ben & Jerry's Factory$n$, $d$The original Ben & Jerry's factory, where you can take a tour, try free samples, and visit the Flavor Graveyard of retired flavors.$d$, $t$A classic Vermont stop, just minutes away.$t$, null::text),
    ($n$Cold Hollow Cider Mill$n$, $d$A Vermont classic for fresh apple cider and famous cider donuts, with a big country store full of local goods.$d$, $t$Get the cider donuts. Trust us.$t$, null::text),
    ($n$Cabot Farmers' Store$n$, $d$A shop for Vermont's famous Cabot cheese, with free samples and lots of local specialty foods.$d$, $t$Sample before you buy.$t$, null::text),
    ($n$Little River State Park$n$, $d$A large state park on the Waterbury Reservoir with swimming, paddling, and trails, including old historic farm settlement sites in the woods.$d$, $t$Great for a summer swim or an easy hike.$t$, null::text),
    ($n$Stowe Pinnacle$n$, $d$A short but steep hike to a rocky summit with great views of Mount Mansfield and the Stowe valley.$d$, null::text, null::text),
    ($n$Mount Mansfield$n$, $d$Vermont's highest peak, with several trails up and incredible views from the top.$d$, null::text, null::text),
    ($n$Cady Hill Forest$n$, $d$A popular Stowe trail network loved by mountain bikers, with flowy trails for a range of abilities.$d$, $t$Great mountain bike trails.$t$, null::text),
    ($n$The Driving Range Adaptive Mountain Bike Trails$n$, $d$A trail network designed to be accessible for adaptive mountain biking.$d$, null::text, null::text)
    ) as v(name, description, host_note, subcategory)
  loop
    update public.recommendations
    set
      description = rec.description,
      host_note = rec.host_note,
      subcategory = coalesce(rec.subcategory, subcategory)
    where name = rec.name;

    if not found then
      raise exception 'Missing recommendation: %', rec.name;
    end if;
  end loop;
end
$body$;

notify pgrst, 'reload schema';
