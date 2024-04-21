//
//  LocationsDataService.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//https://www.givefood.org.uk/api/2/docs/#foodbanks/search
//https://www.givefood.org.uk/api/2/docs/#foodbanks/search

import Foundation
import MapKit

class LocationsDataService{
    
    static let locations: [Location] = [
    Location(
        name: "Westminster",
    // cityName: ,
  address: "Westminster Chapel Buckingham Gate",
        cityName: "London",
      postcode: "SW1E 6BS",
        coordinates: CLLocationCoordinate2D(latitude: 51.49888499999999, longitude: -0.138101),
        phone: "02078341731 x224",
      email: "foodbank@westminsterchapel.org.uk",
       link:"https://westminsterchapel.org.uk/foodbank/"
    ),
    
    Location(
        name: "Waterloo, Oasis UK",
    // cityName: ,
  address: "1 Kennington Road",
        cityName: "London",
      postcode: "SW1E 6BS",
        coordinates: CLLocationCoordinate2D(latitude: 51.4981911, longitude: -0.1117999),
        phone: "02079214205",
      email: "foodbank@oasiswaterloo.org",
       link:"https://waterloo.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name:"Elephant & Castle, Salvation Army",
  address:"101 Newington Causeway",
        cityName:"London",
      postcode:"SE1 6BN",
        coordinates: CLLocationCoordinate2D(latitude: 51.4965956, longitude: -0.099385),
        phone:"02073674500",
      email:"info@salvationarmy.org.uk",
       link:"https://www.salvationarmy.org.uk"
    ),
    
    Location(
         name:"Covent Garden Dragon Hall Trust",
   address:"17 Stukeley Street",
         cityName:"London",
       postcode:"WC2B 5LT",
         coordinates: CLLocationCoordinate2D(latitude: 51.5166471, longitude: -0.1225173),
         phone: "02074047274",
       email:"foodbank@cgcc.org.uk",
        link:"https://www.dragonhall.org.uk/food-bank"
     ),
    
    Location(
         name:"Central Southwark Community Hub",
   address:"St Giles Parish Hall, 161 Benhill Road",
         cityName:"London",
         postcode:"SE5 7LL",
         coordinates: CLLocationCoordinate2D(latitude: 51.4743088, longitude: -0.0864751),
         phone:"02077031653",
       email: "office@cschub.co.uk",
        link:"https://www.cschub.co.uk/what-we-do"
     ),
    
    Location(
        name:"Euston",
  address:"28 Phoenix Road",
        cityName: "London",
      postcode:"NW1 1TA",
        coordinates: CLLocationCoordinate2D(latitude:51.5303781, longitude: -0.1325498),
        phone:"07400053838",
      email:"info@euston.foodbank.org.uk",
       link:"https://euston.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name:"Camden Mobile",
  address: "2 Ossulston St, The Saint Pancras and Somers Town Living Centre",
cityName: "London",
      postcode:"NW1 1DF",
        coordinates: CLLocationCoordinate2D(latitude: 51.5310901, longitude:-0.129785),
        phone: "02070183730",
      email: "info@urbancommunityprojects.org.uk",
       link:"https://www.urbancommunityprojects.org.uk/camden-mobile-food-bank"
    ),
    
    Location(
        name: "Southwark",
  address: "121A Peckham High Street, Peckham",
cityName: "London",
      postcode:"SE15 5SE",
        coordinates: CLLocationCoordinate2D(latitude:51.4740883, longitude: -0.0679916),
        phone:"02077320007",
      email:"foodbank.support@pecan.org.uk",
       link:"https://southwark.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name:"St Mark's Church",
  address:"Battersea Rise",
cityName: "London",
      postcode: "SW11 1EJ",
        coordinates: CLLocationCoordinate2D(latitude: 51.4604982, longitude: -0.1702023),
        phone:"02073269428",
      email:"info@wandsworth.foodbank.org.uk",
       link:"https://wandsworth.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name: "Blessed Sacrament Catholic Church",
  address:"Copenhagen Street, Islington",
cityName: "London",
      postcode:"N1 0SR",
        coordinates: CLLocationCoordinate2D(latitude: 51.5368712, longitude: -0.11747),
        phone:"02072263277",
      email:"copenhagenstreet@rcdow.org.uk",
       link:"https://parish.rcdow.org.uk/copenhagenstreet/copenhagen-street-foodbank/"
    ),
    
    Location(
        name:"Hope Church Vauxhall",
  address:"105 Tyers Street",
cityName: "London",
      postcode:"SE11 5HS",
        coordinates: CLLocationCoordinate2D(latitude:  51.48902094591932, longitude: -0.1185164005111175), 
        phone:"02075822618",
      email:"info@hopevauxhall.co.uk",
       link:"https://norwoodbrixton.foodbank.org.uk/?ref=givefood.org.uk"
    ),
    // https://www.givefood.org.uk/api/2/locations/search/?address=E178je
    Location(
          name: "Rukhsana Khan Foundation",
          address:"6-8 Greenleaf Rd, Walthamstow",
  cityName: "London",
        postcode:"E17 6QQ",
          coordinates: CLLocationCoordinate2D(latitude: 51.5877944, longitude: -0.0219414),
          phone:"07980351351",
        email:"rukhsanakhanfoundation@outlook.com",
         link:"https://www.rukhsanakhanfoundation.org/?ref=givefood.org.uk"
      ),
    Location(
          name: "Eat Or Heat",
    address:"1A Jewel Road, Walthamstow",
  cityName: "London",
        postcode:"E17 4QU",
          coordinates: CLLocationCoordinate2D(latitude: 51.58816419999999, longitude: -0.0211144),
          phone:"08007720212",
        email:"info@eatorheat.org",
         link:"http://eatorheat.org/?ref=givefood.org.uk"
      ),
    Location(
          name:"Salvation Army, Walthamstow",
    address:"434 Forest Road, Walthamstow",
  cityName: "London",
        postcode:"E17 4PY",
          coordinates: CLLocationCoordinate2D(latitude: 51.5906492, longitude: -0.0210373),
          phone:"02085213029",
        email:"walthamstow@salvationarmy.org.uk",
         link:"https://www.salvationarmy.org.uk/?ref=givefood.org.uk"
      ),
    
    Location(
          name: "Hackney, Upper Clapton",
    address:"The Leaside Trust, 34 Spring Lane",
  cityName: "London",
        postcode:"E5 9HQ",
          coordinates: CLLocationCoordinate2D(latitude: 51.5701966, longitude: -0.05472639999999999),
          phone:"02072542464",
        email:"info@hackneyfoodbank.org",
         link:"https://www.hackney.foodbank.org.uk/?ref=givefood.org.uk"
      ),
    Location(
          name: "Leytonstone, Salvation Army",
    address: "Southwell Grove Road, Leytonstone",
  cityName: "London",
        postcode:"E11 4PP",
          coordinates: CLLocationCoordinate2D(latitude: 51.561084, longitude: 0.00711),
          phone:"02085587290",
        email:"leytonstone@salvationarmy.org.uk",
         link: "https://www.salvationarmy.org.uk/?ref=givefood.org.uk"
      ),
    
    Location(
          name:"Wally Foster Community Centre",
    address:"Homerton Road, Hackney",
  cityName: "London",
        postcode:"E9 5QB",
          coordinates: CLLocationCoordinate2D(latitude: 51.55020680000001, longitude: -0.0343846),
          phone:"02072542464",
        email:"info@hackneyfoodbank.org",
         link:"https://www.hackney.foodbank.org.uk/?ref=givefood.org.uk"
      ),
    
    Location(
          name: "Clapton with Stoke Newington and Dalston Plants",
    address:"122-124 Lower Clapton Road",
  cityName: "London",
        postcode:"E5 0QR",
          coordinates: CLLocationCoordinate2D(latitude: 51.553712, longitude: -0.053324),
          phone:"02089853902",
        email:"clapton.corps@salvationarmy.org.uk",
         link:"https://www.salvationarmy.org.uk/?ref=givefood.org.uk"
      ),
    
    Location(
          name:"St Pauls Church",
    address:"65 Maryland Rd, Stratford",
  cityName: "London",
        postcode:"E15 1JL",
          coordinates: CLLocationCoordinate2D(latitude: 51.5477406, longitude: 0.0012295),
          phone:"02085341164",
        email:"rev.ivo.anderson@gmail.com",
         link:"http://www.churchesfoodbank.org.uk/?ref=givefood.org.uk"
      ),
    
    Location(
          name:"Tottenham, Trussell Trust",
    address:"The Tottenham Town Hall, Town Hall Approach Road",
  cityName: "London",
        postcode:"N15 4RY",
          coordinates: CLLocationCoordinate2D(latitude: 51.5872187, longitude: -0.0725467),
          phone: "07939987566",
        email:"info@tottenham.foodbank.org.uk",
         link: "https://tottenham.foodbank.org.uk/?ref=givefood.org.uk"
      ),
    
    Location(
          name:"Highway Vineyard Church",
    address:"88a Romford Road, Stratford",
  cityName: "London",
        postcode:"E15 4EH",
          coordinates: CLLocationCoordinate2D(latitude: 51.5429174, longitude: 0.0106651),
          phone:"02085344019",
        email:"info@highwaychurch.org",
         link:"https://www.highwayvineyard.org/foodbank?ref=givefood.org.uk"
      ),
    Location(
          name:"Tarling East Community Centre",
    address:"63 Martha Street, Shadwell",
  cityName: "London",
        postcode:"E1 2PA",
          coordinates: CLLocationCoordinate2D(latitude: 51.5122435, longitude:-0.054873),
          phone:"02080887650",
        email:"info@aishahhelp.com",
         link: "https://www.facebook.com/groups/628117188029280/"
      ),
    Location(
          name:"St Mary's Church, Bow",
    address:"230 Bow Road",
  cityName: "London",
        postcode: "E3 3BT",
          coordinates: CLLocationCoordinate2D(latitude: 51.5287753, longitude: -0.0167013),
          phone:"07398776145",
        email:"info@bowfoodbank.org",
         link:"https://www.bowfoodbank.org/donate-food/"
      ),
    Location(
          name: "Arc Centre",
    address:"98b St Paul Street",
  cityName: "London",
        postcode:"N1 7DF",
          coordinates: CLLocationCoordinate2D(latitude: 51.5359565, longitude: -0.09607009999999999),
          phone:"02076831281",
        email:"hello@thearccentre.org",
         link:"https://www.thearccentre.org/foodbank"
      ),
    
    Location(
        name:"Islington, Highbury Roundhouse",
    address:"71 Ronalds Road",
  cityName: "London",
        postcode:"N5 1XB",
          coordinates: CLLocationCoordinate2D(latitude: 51.5508393, longitude: -0.1040395),
          phone:"07753222755",
        email:"info@islington.foodbank.org.uk",
         link:"https://islington.foodbank.org.uk/give-help/donate-food/"
      ),
    Location(
          name: "Lions Food Hub, Millwall Community Trust",
    address: "Bolina Road",
  cityName: "London",
        postcode:"SE16 3LD",
          coordinates: CLLocationCoordinate2D(latitude: 51.4869877, longitude:-0.0523671),
          phone:"02077400503",
        email:"lionsfoodhub@gmail.com",
         link:"https://www.bankuet.co.uk/lionsfoodhub"
      ),
    Location(
        name: "Sufra NW London",
  address:"160 Pitfield Way, Stonebridge",
cityName: "London",
      postcode:"NW10 0PW",
        coordinates: CLLocationCoordinate2D(latitude: 51.5488722, longitude:-0.2660904),
        phone: "02034411335",
      email:"admin@sufra-nwlondon.org.uk",
       link:"https://www.sufra-nwlondon.org.uk/get-involved/food-donations/"
    ),
    
    Location(
          name:"Vestry Hall, Brent",
    address:"Neasden Lane",
  cityName: "London",
        postcode:"NW10 2TS",
          coordinates: CLLocationCoordinate2D(latitude:51.5496339, longitude: -0.2492333),
          phone:"02037455972",
        email:"info@brent.foodbank.org.uk",
         link:"https://brent.foodbank.org.uk/give-help/donate-food/"
      ),
    
    Location(
          name:"West Ealing",
    address: "65 Tawny Close",
  cityName: "London",
        postcode:"W13 9LX",
          coordinates: CLLocationCoordinate2D(latitude: 51.509829, longitude: -0.320165),
          phone:"02088409428",
        email:"info@ealing.foodbank.org.uk",
         link:"https://ealing.foodbank.org.uk/give-help/donate-food/"
      ),
    
    Location(
          name:"Notting Hill Methodist Church",
    address:"240 Lancaster Rd, Kensington & Chelsea",
  cityName: "London",
        postcode:"W11 4AH",
          coordinates: CLLocationCoordinate2D(latitude: 51.5150198, longitude: -0.2139442),
          phone:"02037289003",
        email:"info@kensingtonchelsea.foodbank.org.uk",
         link: "https://kensingtonchelsea.foodbank.org.uk/give-help/donate-food/"
      ),
    Location(
          name: "North Paddington",
    address:"57 Goldney Road",
  cityName: "London",
        postcode:"W9 2AR",
          coordinates: CLLocationCoordinate2D(latitude: 51.5247839, longitude: -0.1967077),
          phone:"07932623443",
        email:"info@npfoodbank.org.uk",
         link:"https://www.npfoodbank.org.uk/"
      ),
    Location(
          name: "Granville Community Kitchen",
    address:"The Granville, 140 Carlton Vale",
  cityName: "London",
        postcode:"NW6 5HE",
          coordinates: CLLocationCoordinate2D(latitude:51.53271549999999,longitude: -0.197372),
          phone:"07543824439",
        email:"granvillecommunitykitchen@gmail.com",
         link:"https://granvillecommunitykitchen.org.uk"
      ),
    
    Location(
          name:"Sacred Heart Church",
    address:"Quex Road, Kilburn",
  cityName: "London",
        postcode:"NW6 4PS",
          coordinates: CLLocationCoordinate2D(latitude: 51.5407388, longitude: -0.1938647),
          phone:"02076241701",
        email:"kilburn@rcdow.org.uk",
         link:"https://parish.rcdow.org.uk/kilburn/parish-groups/quex-road-food-bank/"
      )
    ,
    Location(
          name:"Hounslow Community FoodBox",
    address:"Rose Community Centre, Hawthorn Road, Brentford",
  cityName: "London",
        postcode:"TW8 8NT",
          coordinates: CLLocationCoordinate2D(latitude: 51.4807, longitude: -0.3191899),
          phone:"07719891787",
        email:"info@hounslowfoodbox.org.uk",
         link:"https://hounslowfoodbox.org.uk/get-involved-how-to-support-us/donate-food-and-toiletries/"
      )
    ,
    Location(
          name: "AY Group",
    address:"Estate Office Block A, Peabody Hall, Fulham Estate, Lillie Road",
  cityName: "London",
        postcode:"SW6 1UH",
          coordinates: CLLocationCoordinate2D(latitude:51.48525619999999, longitude: -0.2017155),
          phone: "02073818502",
        email:"office@ay-group.org",
         link:"https://www.ay-group.org"
      ),
    
    Location(
          name: "Dad's House",
    address:"22 Lillie Road",
  cityName: "London",
        postcode:"SW6 1TS",
          coordinates: CLLocationCoordinate2D(latitude: 51.4868421, longitude: -0.1975274),
          phone:"07765183504",
        email:"info@dadshouse.org.uk",
         link:"https://www.dadshouse.org.uk/"
      ),

    Location(
          name:"St. Matthews Church, Hammersmith & Fulham",
    address:"Wandsworth Bridge Road",
  cityName: "London",
        postcode:"SW6 2TX",
          coordinates: CLLocationCoordinate2D(latitude: 51.4688764, longitude: -0.1905366),
          phone: "02077313693",
        email: "info@hammersmithfulham.foodbank.org.uk",
         link:"https://hammersmithfulham.foodbank.org.uk/give-help/donate-food/"
      ),
    
    Location(
          name:"Liberty",
    address:"1A Norbury Crescent, Norbury",
  cityName: "London",
        postcode:"SW16 4JS",
          coordinates: CLLocationCoordinate2D(latitude: 51.4109242, longitude: -0.1221567),
          phone:"02086799701",
        email:"admin@libertychurchnorbury.co.uk",
         link:"https://libertychristianministries.co.uk/food-bank/"
      ),
    
    Location(
          name:"St. Andrews Church",
    address:"Wayneflete Street, Earlsfield",
  cityName: "London",
        postcode:"SW18 3QG",
          coordinates: CLLocationCoordinate2D(latitude: 51.440259, longitude: -0.1864904),
          phone:"07480504759",
        email:"earlsfieldfoodbank@gmail.com",
         link:"https://www.earlsfieldfoodbank.org.uk/donate-food"
      ),
    Location(
          name:"SLRA, South London Refugee Association",
    address:"The Woodlawns Centre, 16 Leigham Court Road",
  cityName: "London",
        postcode:"SW16 2PJ",
          coordinates: CLLocationCoordinate2D(latitude:51.4356497, longitude:-0.1246748),
          phone:"02034903443",
        email:"admin@slr-a.org.uk",
         link:"https://www.slr-a.org.uk/get-involved/donate-goods/"
      ),
    Location(
          name:"St Margaret's Church, Norwood & Brixton",
    address:"Barcombe Ave, Streatham Hill",
  cityName: "London",
        postcode:"SW2 3BH",
          coordinates: CLLocationCoordinate2D(latitude: 51.438458, longitude: -0.1197592),
          phone:"07722121108",
        email:"info@norwoodbrixton.foodbank.org.uk",
         link:"https://norwoodbrixton.foodbank.org.uk/give-help/donate-food/"
      ),
    Location(
          name:"Melvin Hall Community Centre",
    address:"Melvin Road, Penge",
  cityName: "London",
        postcode:"SE20 8EU",
          coordinates: CLLocationCoordinate2D(latitude: 51.4110354, longitude: -0.0574575),
          phone:"02087788246",
        email: "melvinhallcommunitygroup@hotmail.com",
         link:"https://melvinhall.org"
      ),
    
    Location(
        name: "We Care",
  address:"50 Friendly Street",
cityName: "London",
      postcode:"SE8 4DR",
        coordinates: CLLocationCoordinate2D(latitude: 51.4713868, longitude:-0.025283),
        phone: "07562085807",
      email:"rusheygreen@googlemail.com",
       link:"https://www.lewishamlocal.com/places/united-kingdom/greater-london/london/area/we-care-foodbank/"
    )
    ,  Location(
        name:"Living Well Bromley",
  address:"Holy Trinity Church, 66 Lennard Road",
cityName: "London",
      postcode:"SE20 7LX",
        coordinates: CLLocationCoordinate2D(latitude: 51.4187681, longitude: -0.048747),
        phone:"07864591607",
      email:"hello@livingwell.life",
       link: "https://livingwell.life/p/donatefood"
    ),
    
    Location(
        name:"St Peter's Brockley",
  address: "St Peter's Brockley, Wickham Road",
cityName: "London",
      postcode:"SE4 1LT",
        coordinates: CLLocationCoordinate2D(latitude: 51.4650742, longitude: -0.0306318),
        phone:"02084690013",
      email:"anne@stpetersbrockley.org.uk",
       link:"https://www.stpetersbrockley.org.uk/food-items"
    ),
    
    Location(
          name:"Greenwich",
    address:"Unit 1, 80 Shooters Hill",
  cityName: "London",
        postcode: "SE18 3HY",
          coordinates: CLLocationCoordinate2D(latitude:51.468045, longitude: 0.0693744),
          phone: "02088503855",
        email:"info@greenwich.foodbank.org.uk",
         link:"https://greenwich.foodbank.org.uk/donate/donate-food/"
      ),
    
    Location(
          name:"Avery Hill Christian Fellowship, Bexley",
    address:"Southspring, Sidcup",
  cityName: "London",
        postcode:"DA15 8EA",
          coordinates: CLLocationCoordinate2D(latitude: 51.4455181, longitude: 0.0847508),
          phone:"07932431350",
        email:"info@bexley.foodbank.org.uk",
         link: "https://bexley.foodbank.org.uk/give-help/donate-food/"
      ),
    
    Location(
          name:"AFRIL",
    address:"F3 Leemore Central Community Hub, Bonfield Road, Lewisham",
  cityName: "London",
        postcode:"SE13 5ES",
          coordinates: CLLocationCoordinate2D(latitude: 51.459947, longitude: -0.007360999999999999),
          phone:"02082974111",
        email:"foodbank@afril.org.uk",
         link: "http://www.afril.org.uk/food-bank/"
      ),
    
    
    Location(
          name:"Lewisham",
    address: "New Hope Centre, 353H Bromley Road",
  cityName: "London",
        postcode:"SE6 2RP",
          coordinates: CLLocationCoordinate2D(latitude: 51.42794319999999, longitude: -0.0112152),
          phone:"07938071854",
        email:"info@lewisham.foodbank.org.uk",
         link:"https://lewisham.foodbank.org.uk/give-help/donate-food/"
      )
    ,
    Location(
          name:"CEYP",
    address: "4-8 Pound Place",
  cityName: "London",
        postcode:"SE9 5DN",
          coordinates: CLLocationCoordinate2D(latitude: 51.4504122, longitude:0.05786310000000001),
          phone:"02088596644",
        email:"info@ceyp.org",
         link:"https://www.ceyp.org"
      ),
    
    Location(
        name:"Whitefoot and Downham",
  address:"Hope Church Downham, 480 Whitefoot Lane, Downham",
cityName: "London",
      postcode:"BR1 5SF",
        coordinates: CLLocationCoordinate2D(latitude: 51.43391279999999, longitude: 0.0085617),
        phone:"02086987945",
      email:"info@wdcfplus.org.uk",
       link:"http://wdcfplus.org.uk"
    )
// https://www.givefood.org.uk/api/2/foodbanks/search/?address=E11bj
// https://www.givefood.org.uk/api/2/foodbanks/search/?address=W30AD
// https://www.givefood.org.uk/api/2/foodbanks/search/?address=E177JR
// https://www.givefood.org.uk/api/2/foodbanks/search/?address=SW25BZ
    




    

    
    
    ]
}

